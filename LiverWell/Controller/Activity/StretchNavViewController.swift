//
//  StretchNavViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/24.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class StretchNavViewController: UINavigationController {

    var workoutMinutes: Float?
    var workoutArray: [WorkoutSet]?
    var navTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rootViewController = viewControllers.first as? StretchCountdownViewController {
            rootViewController.workoutMinutes = workoutMinutes
            rootViewController.workoutArray = workoutArray
            rootViewController.navTitle = navTitle
        }
        
    }
}
