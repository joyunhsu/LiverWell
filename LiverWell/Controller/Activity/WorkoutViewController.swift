//
//  WorkoutViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/11.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name
class WorkoutViewController: UIViewController {
    
    @IBOutlet weak var workoutTitleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var repeatCollectionView: UICollectionView!
    
    @IBOutlet weak var barProgressView: UIProgressView!
    
    var timer: Timer?
    
    var repeatCounts = [String]()
    
    var startTime = 0
    
    var counter = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        changeRepeatCounts(totalCount: 10, timeInterval: 1)

    }
    
    func changeRepeatCounts(totalCount: Int, timeInterval: TimeInterval) {
    
        for i in 1...totalCount {
            let repeatCount = "\(i)/10次"
            repeatCounts.append(repeatCount)
    
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            
            if self.counter < totalCount {
                self.repeatLabel.text = self.repeatCounts[self.counter]
            }
            
            self.counter += 1
            
        })
    
    }

}
