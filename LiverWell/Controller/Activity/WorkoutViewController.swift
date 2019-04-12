//
//  WorkoutViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/11.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name
class WorkoutViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var workoutTitleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var repeatCollectionView: UICollectionView!
    
    @IBOutlet weak var barProgressView: UIProgressView!
    
    var timer: Timer?
    
    var repeatCountingText = [String]()
    
    var nowRepeat = 1
    
    var totalRepeat = 2
    
    var startTime = 0
    
    var counter = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        counter = 1
        self.repeatLabel.text = "\(counter)/10次"
        changeRepeatCounts(totalCount: 10, timeInterval: 1)
        
        repeatCollectionView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
    }
    
    func changeRepeatCounts(totalCount: Int, timeInterval: TimeInterval) {
        
        for i in 1...totalCount {
            let repeatCount = "\(i)/10次"
            repeatCountingText.append(repeatCount)
            
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            
            if self.counter < totalCount {
                self.repeatLabel.text = self.repeatCountingText[self.counter]
                
                self.counter += 1
            } else {
                self.timer?.invalidate()
                self.performSegue(withIdentifier: "startRest", sender: self)
                self.nowRepeat += 1
            }
            
        })
        
    }
    
}

extension WorkoutViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalRepeat
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = repeatCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: RepeatCollectionViewCell.self),
            for: indexPath
        )
        
        guard let repeatCell = cell as? RepeatCollectionViewCell else { return cell }
        
        var bgColorArray = [UIColor?]()
        var textColorArray = [UIColor?]()
        
        for _ in 0..<totalRepeat {
            let defaultViewColor = UIColor.B5
            bgColorArray.append(defaultViewColor)
            
            let defaultTextColor = UIColor.B1
            textColorArray.append(defaultTextColor)
        }
        
        for i in 0..<nowRepeat {
            let finishedViewColor = UIColor.G2
            bgColorArray[i] = finishedViewColor
            
            let finishedTextColor = UIColor.white
            textColorArray[i] = finishedTextColor
        }
        
        repeatCell.counterLabel.text = String(indexPath.item + 1)
        repeatCell.counterLabel.textColor = textColorArray[indexPath.item]
        repeatCell.cellBackground.backgroundColor = bgColorArray[indexPath.item]
        
        return repeatCell
    }
    
}

extension WorkoutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        let collectionViewWidth = repeatCollectionView.bounds.width
        let cellSpace = Int(collectionViewWidth) / totalRepeat
        return CGSize(width: cellSpace, height: 25)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 0
    }
    
}
