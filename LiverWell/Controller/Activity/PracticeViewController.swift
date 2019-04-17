//
//  PracticeViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class PracticeViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate {

    @IBOutlet weak var progressCollectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var previousBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
//    var workoutSet: [Workout]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstCell = UINib(
            nibName: String(describing: FirstActivityInfoTableViewCell.self),
            bundle: nil
        )
        
        tableView.register(
            firstCell,
            forCellReuseIdentifier: String(describing: FirstActivityInfoTableViewCell.self)
        )
        
        let secondCell = UINib(
            nibName: String(describing: SecondActivityInfoTableViewCell.self),
            bundle: nil
        )
        
        tableView.register(
            secondCell,
            forCellReuseIdentifier: String(describing: SecondActivityInfoTableViewCell.self)
        )

    }
    
    @IBAction func dismissBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}

extension PracticeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FirstActivityInfoTableViewCell.self),
            for: indexPath
        )
        
        let cellReuse = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SecondActivityInfoTableViewCell.self),
            for: indexPath
        )
        
        guard let firstCell = cell as? FirstActivityInfoTableViewCell else { return cell }
        
        guard let secondCell = cellReuse as? SecondActivityInfoTableViewCell else { return cell }
        
        switch indexPath.row {
            
        case 0: return firstCell
            
        default: return secondCell
            
        }
    }
    
}

extension PracticeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let workoutSet = workoutSet else { return 0 }
//        return workoutSet.count
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = progressCollectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCell", for: indexPath)
        
        return cell
        
    }
    
}

extension PracticeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let workoutCount = workoutSet?.count else { return CGSize() }
//        let workoutCountCGFlaot = CGFloat(workoutCount)
//        let cellWidth = (self.view.frame.width - (workoutCountCGFlaot - 1) * 2) / workoutCountCGFlaot
        let cellWidth = (self.view.frame.width - 6) / 4
        
        return CGSize(width: cellWidth, height: 5)
    }

}
