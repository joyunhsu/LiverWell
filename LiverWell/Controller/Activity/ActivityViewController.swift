//
//  ActivityViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/2.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class ActivityViewController: LWBaseViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    
    deinit {
        print("ActivityVC deinit")
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!

    @IBOutlet var orderBtns: [UIButton]!

    var tableViews: [UICollectionView] {

        return [firstCollectionView, secondCollectionView]

    }

    let manager = ActivityManager()
    
    let workoutManager = WorkoutManager()
    
    var trainElements: [WorkoutElement]? {
        didSet {
            firstCollectionView.reloadData()
        }
    }
    
    var stretchElements: [WorkoutElement]? {
        didSet {
            secondCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutManager.getWorkout(activity: ActivityItems.train) { [weak self] (train, _ ) in
            self?.trainElements = train
        }
        
        workoutManager.getWorkout(activity: ActivityItems.stretch) { [weak self] (stretch, _ ) in
            self?.stretchElements = stretch
        }

        scrollView.delegate = self
        
        firstCollectionView.lw_registerCellWithNib(
            identifier: String(describing: HeaderCollectionViewCell.self),
            bundle: nil)
        
        secondCollectionView.lw_registerCellWithNib(
            identifier: String(describing: HeaderCollectionViewCell.self),
            bundle: nil)
        
        firstCollectionView.lw_registerCellWithNib(
            identifier: String(describing: ActivityCollectionViewCell.self),
            bundle: nil)
        
        secondCollectionView.lw_registerCellWithNib(
            identifier: String(describing: ActivityCollectionViewCell.self),
            bundle: nil)

        self.navigationController?.isNavigationBarHidden = true

    }

    @IBAction func changePagePressed(_ sender: UIButton) {

        for btn in orderBtns {

            btn.isSelected = false

        }

        sender.isSelected = true

        moveIndicatorView(toPage: sender.tag)
    }

    private func moveIndicatorView(toPage: Int) {

        let screenWidth  = UIScreen.main.bounds.width

        indicatorLeadingConstraint.constant = CGFloat(toPage) * screenWidth / 2

        UIView.animate(withDuration: 0.3) {

            self.scrollView.contentOffset.x = CGFloat(toPage) * screenWidth

            self.view.layoutIfNeeded()

        }

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let screenWidth  = UIScreen.main.bounds.width

        indicatorLeadingConstraint.constant = scrollView.contentOffset.x / 2

        let temp = Double(scrollView.contentOffset.x / screenWidth)

        let number = lround(temp)

        for btn in orderBtns {

            btn.isSelected = false

        }
        
        if number < 2 && number >= 0 {
            
            orderBtns[number].isSelected = true
            
            UIView.animate(withDuration: 0.1) {
                
                self.view.layoutIfNeeded()
                
            }
            
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 1 {

            if collectionView == firstCollectionView {

                performSegue(withIdentifier: "setupTrain", sender: nil)

            } else {

                performSegue(withIdentifier: "setupStretch", sender: nil)

            }

        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let trainDestination = segue.destination as? TrainSetupViewController {

            var indexPath = self.firstCollectionView.indexPathsForSelectedItems?.first
            
            guard let trainElements = trainElements else { return }
            
            let passItem = trainElements[indexPath!.row]
            
            trainDestination.idUrl = passItem.id
            
        }

        if let stretchDestination = segue.destination as? StretchSetupViewController {

            var indexPath = self.secondCollectionView.indexPathsForSelectedItems?.first
            
            guard let stretchElements = stretchElements else { return }
            
            let passItem = stretchElements[indexPath!.row]
            
            stretchDestination.idUrl = passItem.id

        }

    }

}

extension ActivityViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else {
            
            switch collectionView {
                
            case firstCollectionView: return trainElements?.count ?? 0
                
            case secondCollectionView: return stretchElements?.count ?? 0
                
            default: return 0
                
            }
            
        }
        
    }
    
    func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "HeaderCollectionViewCell",
                for: indexPath
            )
            
            guard let headerCell = cell as? HeaderCollectionViewCell else { return cell }
            
            let trainGroup = manager.trainGroup
            let stretchGroup = manager.stretchGroup
            if collectionView == firstCollectionView {
                
                headerCell.layoutCell(
                    firstLine: trainGroup.firstLineTitle,
                    secondLine: trainGroup.secondLineTitle,
                    caption: trainGroup.caption,
                    crossImage: #imageLiteral(resourceName: "Image_OrangeCross.png"),
                    corner: .bottomLeft
                )
                
            } else {
                
                headerCell.layoutCell(
                    firstLine: stretchGroup.firstLineTitle,
                    secondLine: stretchGroup.secondLineTitle,
                    caption: stretchGroup.caption,
                    crossImage: #imageLiteral(resourceName: "Image_GreenCross"),
                    corner: .bottomRight
                )
                
            }
            
            return headerCell
            
        } else {
            
            if collectionView == firstCollectionView {
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ActivityCollectionViewCell",
                    for: indexPath
                )
                
                guard let trainCell = cell as? ActivityCollectionViewCell else { return cell }
                
                guard let trainElements = trainElements else { return cell }
                
                let trainItems = trainElements[indexPath.row]
                
                trainCell.layoutView(title: trainItems.title, image: trainItems.icon)
                
                return trainCell
                
            } else if collectionView == secondCollectionView {
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ActivityCollectionViewCell",
                    for: indexPath
                )
                
                guard let stretchCell = cell as? ActivityCollectionViewCell else { return cell }
                
                guard let stretchElements = stretchElements else { return cell }
                
                let stretchItems = stretchElements[indexPath.row]
                
                stretchCell.layoutView(title: stretchItems.title, image: stretchItems.icon)
                
                return stretchCell
                
            }
            
            return UICollectionViewCell()
            
        }
        
    }
    
}

extension ActivityViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {

            return CGSize(width: view.frame.width, height: 166)

        } else {

            switch collectionView {

            case firstCollectionView: return CGSize(width: (firstCollectionView.bounds.width - 20) / 2.0, height: 152.0)

            default: return CGSize(width: (secondCollectionView.bounds.width - 20) / 2.0, height: 152.0)

            }

        }

    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 26
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
        ) -> UIEdgeInsets {

        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        }

    }

}
