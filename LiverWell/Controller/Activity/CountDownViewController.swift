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
    
    var timer = Timer()
    var counter = 5
    var workoutMinutes: Float?
    var workoutArray: [WorkoutSet]?

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
            countDownLabel.text = String(format: "%d", counter)
        } else {
            performSegue(withIdentifier: "startWorkout", sender: self)
            timer.invalidate()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desVC = segue.destination as? WorkoutViewController,
            let workoutMinutes = workoutMinutes {
            desVC.workoutMinutes = workoutMinutes
            desVC.workoutArray = workoutArray
        }
        
        if let pauseVC = segue.destination as? PauseViewController {
            pauseVC.currentTime = 0
            pauseVC.maxTime = 1
        }
    }
}
