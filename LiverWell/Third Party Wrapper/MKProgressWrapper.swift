//
//  MKProgressWrapper.swift
//  LiverWell
//
//  Created by Jo Yun Hsu on 2019/6/9.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation
import MKProgress

class ProgressHud {
    
    static func showProgressHud() {
        configProgressHud()
        MKProgress.show()
    }
    
    static func hideProgressHud() {
        MKProgress.hide()
    }
    
    static func configProgressHud() {
        MKProgress.config.hudType = .radial
        MKProgress.config.hudColor = .white
        MKProgress.config.backgroundColor = UIColor(white: 0, alpha: 0.55)
        MKProgress.config.cornerRadius = 16.0
        MKProgress.config.fadeInAnimationDuration = 0.2
        MKProgress.config.fadeOutAnimationDuration = 0.25
        MKProgress.config.hudYOffset = 15
        
        MKProgress.config.circleRadius = 30.0
        MKProgress.config.circleBorderWidth = 2.0
//        MKProgress.config.circleBorderColor = .darkGray
//        MKProgress.config.circleAnimationDuration = 0.9
//        MKProgress.config.circleArcPercentage = 0.85
//        MKProgress.config.logoImageSize = CGSize(width: 40, height: 40)
        
        MKProgress.config.activityIndicatorStyle = .whiteLarge
        MKProgress.config.activityIndicatorColor = .black
        MKProgress.config.preferredStatusBarStyle = .lightContent
        MKProgress.config.prefersStatusBarHidden = false
    }
}
