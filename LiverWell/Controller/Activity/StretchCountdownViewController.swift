//
//  StretchCountdownViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/5/5.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import AVFoundation

class StretchCountdownViewController: UIViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var workoutTItle: UILabel!
    
    @IBOutlet weak var workoutImage: UIImageView!
    
    @IBOutlet weak var barProgressView: UIProgressView!
    
    var timer = Timer()
    var counter = 5
    var workoutMinutes: Float?
    var workoutArray: [WorkoutSet]?
    var workoutIndex = 0
    var navTitle: String?
    var currentTime: Float = 0.0
//    var maxTime: Float = 0.0
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
        
        counter = 5
        
        workoutIndex += 1
        
    }
    
    @IBAction func unwindtoCountdown(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )
        
        let maxTime = workoutMinutes! * 60.0
        
        barProgressView.progress = currentTime / maxTime
        
        guard let workoutArray = workoutArray else { return }
        
        workoutImage.image = UIImage(named: workoutArray[workoutIndex].thumbnail)
        
        workoutTItle.text = workoutArray[workoutIndex].title
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countDownLabel.text = "\(counter)"
        
        setupAudioPlayer()
        
        audioPlayer.play()
        
        navigationItem.title = navTitle
        
    }
    
    @objc func updateTimer() {
        if counter > 0 {
            counter -= 1
            countDownLabel.text = String(format: "%d", counter)
            
            audioPlayer.play()
            
        } else {
            performSegue(withIdentifier: "prepareStretch", sender: self)
            timer.invalidate()
        }
        
    }
    
    private func setupAudioPlayer() {
        
        let sound = Bundle.main.path(forResource: "Countdown", ofType: "mp3")
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            print(error)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desVC = segue.destination as? StretchPrepareViewController,
            let workoutMinutes = workoutMinutes {
            desVC.workoutMinutes = workoutMinutes
            desVC.currentTime = currentTime
            desVC.workoutArray = workoutArray
            desVC.navTitle = navTitle
            desVC.workoutIndex = workoutIndex
        }
        
        if let pauseVC = segue.destination as? PauseViewController {
            pauseVC.currentTime = self.currentTime
            pauseVC.maxTime = workoutMinutes! * 60
            pauseVC.workoutArray = workoutArray
            pauseVC.workoutIndex = workoutIndex
        }

    }
}
