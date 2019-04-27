//
//  NavigationViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/14.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    
    var workoutMinutes: Float?
    var workoutArray: [WorkoutSet]?
    var navTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rootViewController = viewControllers.first as? CountDownViewController {
            rootViewController.workoutMinutes = workoutMinutes
            rootViewController.workoutArray = workoutArray
            rootViewController.navTitle = navTitle
        }

    }

}
