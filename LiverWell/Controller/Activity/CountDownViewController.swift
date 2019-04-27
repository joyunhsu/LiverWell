//
//  CountDownViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/11.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import AVFoundation

class CountDownViewController: UIViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var workoutTItle: UILabel!
    
    @IBOutlet weak var workoutImage: UIImageView!
    
    var timer = Timer()
    var counter = 5
    var workoutMinutes: Float?
    var workoutArray: [WorkoutSet]?
    var navTitle: String?
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
        
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
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countDownLabel.text = "\(counter)"
        
        guard let workoutArray = workoutArray else { return }
        
        workoutImage.image = UIImage(named: workoutArray[0].thumbnail)
        
        workoutTItle.text = workoutArray[0].title
        
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
            performSegue(withIdentifier: "startWorkout", sender: self)
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
        if let desVC = segue.destination as? WorkoutViewController,
            let workoutMinutes = workoutMinutes {
            desVC.workoutMinutes = workoutMinutes
            desVC.workoutArray = workoutArray
            desVC.navTitle = navTitle
        }
        
        if let pauseVC = segue.destination as? PauseViewController {
            pauseVC.currentTime = 0
            pauseVC.maxTime = 1
            pauseVC.workoutArray = workoutArray
        }
    }
}
