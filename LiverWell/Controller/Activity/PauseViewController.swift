//
//  PauseViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/11.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import SwiftMessages

class PauseViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var workoutImageView: UIImageView!
    
    @IBOutlet weak var barProgressView: UIProgressView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentTime: Float = 0.0
    
    var maxTime: Float = 0.0
    
    var workoutArray: [WorkoutSet]?
    
    var workoutIndex = 0
    
    @IBAction func resumeWorkoutPressed(_ sender: UIButton) {
        
        dismiss(animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barProgressView.progress = currentTime / maxTime
        
        tableView.lw_registerCellWithNib(
            identifier: String(describing: FirstActivityInfoTableViewCell.self),
            bundle: nil)
        
        tableView.lw_registerCellWithNib(
            identifier: String(describing: SecondActivityInfoTableViewCell.self),
            bundle: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupGif()
        
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desVC = segue.destination
        let recordTime = lroundf(currentTime / 60)
        
        if let setupVC = desVC as? TrainSetupViewController {
            setupVC.recordTrainTime = recordTime
//            if recordTime >= 0 {
//                showMsgView(minute: recordTime)
//            }
        } else if let setupVC = desVC as? StretchSetupViewController {
            setupVC.recordStretchTime = recordTime
        }
        
    }
    
    private func showMsgView(minute: Int) {

        let msgView = MessageView.viewFromNib(layout: .cardView)
        msgView.configureTheme(.success)
        msgView.configureContent(title: "運動登錄！", body: "完成\(minute)分鐘運動")
        msgView.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        SwiftMessages.show(config: config, view: msgView)
    }
    
    private func setupGif() {
        
        guard let workoutArray = workoutArray else { return }
        let currentWorkout = workoutArray[workoutIndex]
        workoutImageView.animationImages = [
            UIImage(named: currentWorkout.images[0]),
            UIImage(named: currentWorkout.images[1])
            ] as? [UIImage]
        
        workoutImageView.animationDuration = currentWorkout.perDuration
        workoutImageView.startAnimating()
        
    }

}

extension PauseViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        guard let currentWorkout = workoutArray?[workoutIndex] else { return 0 }
//
//        if currentWorkout.annotation != nil {
//            return 2
//        } else {
//            return 1
//        }
        
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
        
        guard let currentWorkout = workoutArray?[workoutIndex] else { return cell }
        
        if indexPath.row == 0 {
            
            firstCell.layoutView(title: currentWorkout.title, description: currentWorkout.description)
            
            return firstCell
            
        } else {
            
            guard let annotation = currentWorkout.annotation else { return UITableViewCell() }
            
            secondCell.layoutView(annotation: annotation[0])
            
            return secondCell
            
        }
    }

}
