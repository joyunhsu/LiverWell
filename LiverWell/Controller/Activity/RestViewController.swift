//
//  RestViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/12.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class RestViewController: UIViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    @IBOutlet weak var barProgressView: UIProgressView!
    
    var timer = Timer()
    
    var counter = 10
    
    var currentTime: Float = 0.0
    
    var maxTime: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        countDownLabel.text = "\(counter)"
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
        
        barProgressView.progress = currentTime / maxTime
        
    }
    
    @objc func updateTimer() {
        
        if counter > 0 {
            counter -= 1
            countDownLabel.text = String(format: "%d", counter)
            progressView.value = CGFloat(30 - counter)
            
        } else {
            
            self.navigationController?.popViewController(animated: false)
            timer.invalidate()
            
        }
    }

}
