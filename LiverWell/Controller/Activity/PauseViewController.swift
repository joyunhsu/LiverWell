//
//  PauseViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/11.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {
    
    @IBAction func resumeWorkoutPressed(_ sender: UIButton) {
        
        dismiss(animated: false)
        
    }
    
    @IBAction func terminateWorkout(_ sender: UIBarButtonItem) {
        
        let activityStoryboard: UIStoryboard = UIStoryboard(name: "Activity", bundle: nil)
        let desVC = activityStoryboard.instantiateViewController(
            withIdentifier: String(describing: TrainSetupViewController.self)
        )
        guard let pauseVC = desVC as? TrainSetupViewController else { return }
        self.present(pauseVC, animated: true)
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
