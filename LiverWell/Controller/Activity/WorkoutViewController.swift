//
//  WorkoutViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/11.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {
    
    @IBAction func pauseWorkoutPressed(_ sender: UIButton) {
        
        let activityStoryboard: UIStoryboard = UIStoryboard(name: "Activity", bundle: nil)
        let desVC = activityStoryboard.instantiateViewController(
            withIdentifier: String(describing: PauseViewController.self)
        )
        guard let pauseVC = desVC as? PauseViewController else { return }
        self.present(pauseVC, animated: false)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
