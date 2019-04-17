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

    @IBOutlet weak var trainProgressView: MBCircularProgressBarView!

    @IBOutlet weak var stretchProgressView: MBCircularProgressBarView!

    @IBOutlet weak var workoutCollectionView: UICollectionView!

    @IBOutlet weak var weekProgressCollectionView: UICollectionView!

    let manager = HomeManager()
    
    let workoutManager = WorkoutManager()
    
    var trainElements: [WorkoutElement]? {
        didSet {
            workoutCollectionView.reloadData()
        }
    }
    
//    var stretchElements: [WorkoutElement]? {
//        didSet {
//            secondCollectionView.reloadData()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutManager.getWorkout(activity: ActivityItems.train) { [weak self] (train, error) in
            self?.trainElements = train
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == workoutCollectionView {

            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Activity", bundle: nil)
            let desVC = mainStoryboard.instantiateViewController(withIdentifier: "TrainSetupViewController")
            guard let trainVC = desVC as? TrainSetupViewController else { return }
            trainVC.loadViewIfNeeded()
            self.present(trainVC, animated: true)

        }
    }

}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == workoutCollectionView {

//            return manager.groups[1].items.count
            return trainElements?.count ?? 0

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

            let item = manager.groups[1].items[indexPath.row]

            homeCell.layoutCell(image: item.image)

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
