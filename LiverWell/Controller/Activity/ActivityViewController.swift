//
//  ActivityViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/2.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

struct Workout {
    
    let title: String
    
    let info: String
    
    let totalRepeat: Int
    
    let totalCount: Int
    
    let perDuration: TimeInterval
    
    let workoutImage: [UIImage]
    
    let practiceDescription: String
    
    let practiceAnnotation: [String]?
    
}

struct WorkoutJson: Codable {
    
    let title: String
    
    let info: String
    
    let totalRepeat: Int
    
    let totalCount: Int
    
    let perDuration: Double
    
    let workoutImage: [String]
    
    let practiceDescription: String
    
    let practiceAnnotation: [String]?
    
}

class ActivityViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    
    let workoutSetTest = [
        WorkoutJson(title: "看電視順便做",
                    info: "轉到手臂有明顯緊繃感為止",
                    totalRepeat: 2,
                    totalCount: 3,
                    perDuration: 4,
                    workoutImage: ["1", "2"],
                    practiceDescription: "1. 雙臂往下拉至後頸部，慢慢感受肩胛骨周圍肌肉受到刺激；注意頸部不可過度施力。雙手向上、向下算一次。\n2. 抬頭挺胸，雙手握住毛巾兩端後往上伸直。進行時，手臂放在身後。",
                    practiceAnnotation: nil),
        WorkoutJson(title: "預防腰痛",
                    info: "轉到手臂有明顯緊繃感為止",
                    totalRepeat: 3,
                    totalCount: 5,
                    perDuration: 4,
                    workoutImage: ["1", "2"],
                    practiceDescription: "1. 雙臂往下拉至後頸部，慢慢感受肩胛骨周圍肌肉受到刺激；注意頸部不可過度施力。雙手向上、向下算一次。\n2. 抬頭挺胸，雙手握住毛巾兩端後往上伸直。進行時，手臂放在身後。",
                    practiceAnnotation: nil)
    
    ]

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let jsonData = try JSONEncoder().encode(workoutSetTest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
            
            // and decode it back
            let decodedSentences = try JSONDecoder().decode([WorkoutJson].self, from: jsonData)
            print(decodedSentences)
        } catch { print(error) }

        scrollView.delegate = self

        let headerCellNib = UINib(nibName: "HeaderCollectionViewCell", bundle: nil)

        firstCollectionView.register(headerCellNib, forCellWithReuseIdentifier: "HeaderCollectionViewCell")

        secondCollectionView.register(headerCellNib, forCellWithReuseIdentifier: "HeaderCollectionViewCell")

        let cellNib = UINib(nibName: "ActivityCollectionViewCell", bundle: nil)

        firstCollectionView.register(cellNib, forCellWithReuseIdentifier: "ActivityCollectionViewCell")

        secondCollectionView.register(cellNib, forCellWithReuseIdentifier: "ActivityCollectionViewCell")

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

        orderBtns[number].isSelected = true

        UIView.animate(withDuration: 0.1) {

            self.view.layoutIfNeeded()

        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 1 {

            if collectionView == firstCollectionView {

                performSegue(withIdentifier: "setupTrain", sender: self)

            } else {

                performSegue(withIdentifier: "setupStretch", sender: self)

            }

        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let trainDestination = segue.destination as? TrainSetupViewController {

            var indexPath = self.firstCollectionView.indexPathsForSelectedItems?.first
//            let itemNumber: Int = indexPath!.item

            let passItem = manager.groups[0].items[indexPath!.item]

            trainDestination.navTitle = passItem.title
            print(passItem.title)
        }

        if let stretchDestination = segue.destination as? StretchSetupViewController {

            var indexPath = self.secondCollectionView.indexPathsForSelectedItems?.first

            let passItem = manager.groups[1].items[indexPath!.item]

            stretchDestination.navTitle = passItem.title
            print(passItem.title)

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
                
            case firstCollectionView: return manager.groups[0].items.count
                
            case secondCollectionView: return manager.groups[1].items.count
                
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
                
                let trainItems = manager.groups[0].items[indexPath.row]
                
                trainCell.layoutView(title: trainItems.title, image: trainItems.image)
                
                return trainCell
                
            } else if collectionView == secondCollectionView {
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ActivityCollectionViewCell",
                    for: indexPath
                )
                
                guard let stretchCell = cell as? ActivityCollectionViewCell else { return cell }
                
                let stretchItems = manager.groups[1].items[indexPath.row]
                
                stretchCell.layoutView(title: stretchItems.title, image: stretchItems.image)
                
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
