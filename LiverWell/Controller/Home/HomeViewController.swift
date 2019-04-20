//
//  HomeViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/3.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    let homeObjectManager = HomeObjectManager()
    
    var homeObject: HomeObject? {
        didSet {
            workoutCollectionView.reloadData()
            
            setupView()
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var trainProgressView: MBCircularProgressBarView!

    @IBOutlet weak var stretchProgressView: MBCircularProgressBarView!

    @IBOutlet weak var workoutCollectionView: UICollectionView!

    @IBOutlet weak var weekProgressCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStatus(homeStatus: .resting)
        
        showToday()
        
    }
    
    private func showToday() {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM月dd日"
        var convertedDate = dateFormatter.string(from: now)
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        var convertedChineseDay = dayFormatter.string(from: now)
        var chineseDay: String {
            switch convertedChineseDay {
            case "Monday": return "星期一"
            case "Tuesday": return "星期二"
            case "Wedneday": return "星期三"
            case "Thursday": return "星期四"
            case "Friday": return "星期五"
            case "Saturday": return "星期六"
            default: return "星期日"
            }
        }
        
        timeLabel.text = "\(convertedDate) \(chineseDay)"
        
    }
    
    private func setupStatus(homeStatus: HomeStatus) {
        homeObjectManager.getHomeObject(homeStatus: homeStatus) { [weak self] (homeObject, _ ) in
            self?.homeObject = homeObject
        }
    }
    
    private func setupView() {
        
        guard let homeObject = homeObject else { return }
        
        statusLabel.text = homeObject.title
        
        background.image = UIImage(named: homeObject.background)
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == workoutCollectionView {

            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Activity", bundle: nil)
            let desVC = mainStoryboard.instantiateViewController(withIdentifier: "TrainSetupViewController")
            guard let trainVC = desVC as? TrainSetupViewController else { return }
//            trainVC.loadViewIfNeeded()
            trainVC.idUrl = homeObject?.workoutSet[indexPath.item].id
            self.present(trainVC, animated: true)

        }
    }

}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == workoutCollectionView {

            guard let workoutSet = homeObject?.workoutSet else { return 0 }
            
            return workoutSet.count

        } else if collectionView == weekProgressCollectionView {

            return 7

        }

        return Int()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == workoutCollectionView {

            let cell = workoutCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: HomeCollectionViewCell.self),
                for: indexPath)

            guard let homeCell = cell as? HomeCollectionViewCell else { return cell }

//            let item = manager.groups[1].items[indexPath.row]
            
            guard let workoutElement = homeObject?.workoutSet[indexPath.row] else { return cell }

            homeCell.layoutCell(image: workoutElement.buttonImage)

            return homeCell

        } else if collectionView == weekProgressCollectionView {

            let days = ["ㄧ", "二", "三", "四", "五", "六", "日"]

            let cell = weekProgressCollectionView.dequeueReusableCell(
                withReuseIdentifier: "WeekProgressCollectionViewCell", for: indexPath)

            guard let progressCell = cell as? WeekProgressCollectionViewCell else { return cell }

            progressCell.day.text = days[indexPath.item]

            return progressCell

        }

        return UICollectionViewCell()
    }

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == workoutCollectionView {

            return CGSize(width: 165, height: 119)

        } else {

            return CGSize(width: 20, height: 40)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == weekProgressCollectionView {

            return 21

        } else {

            return 0

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == workoutCollectionView {

            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        } else {

            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        }

    }

}
