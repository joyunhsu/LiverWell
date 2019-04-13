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
    
    var timer = Timer()
    var counter = 30
    
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
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//            self.navigationController?.popViewController(animated: false)
//        })
        
    }
    
    @objc func updateTimer() {
        if counter > 0 {
            counter -= 1
            countDownLabel.text = String(format: "%2d", counter)
            progressView.value = CGFloat(30 - counter)
        } else {
            self.navigationController?.popViewController(animated: false)
            timer.invalidate()
        }
    }

}
