//
//  CountDownViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/11.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class CountDownViewController: UIViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBAction func stopWorkoutPressed(_ sender: UIButton) {
        
//        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true)
        
    }
    
    var timer = Timer()
    var counter = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countDownLabel.text = "\(counter)"
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
        
    }
    
    @objc func updateTimer() {
        if counter > 0 {
            counter -= 1
            countDownLabel.text = String(format: "%2d", counter)
        } else {
            performSegue(withIdentifier: "startWorkout", sender: self)
            timer.invalidate()
        }
    }
}
