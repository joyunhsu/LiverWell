//
//  UIImage+Extension.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/2.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    // Tab
    case Icon_24px_Home_Normal
    case Icon_24px_Home_Selected
    case Icon_24px_Workout_Normal
    case Icon_24px_Workout_Selected
    case Icon_24px_Knowledge_Normal
    case Icon_24px_Knowledge_Selected
    case Icon_24px_Profile_Normal
    case Icon_24px_Profile_Selected
    
    // Activity tab - Train
    case Icon_Workout_BackPain
    case Icon_Workout_LowerBody
    case Icon_Workout_TV
    case Icon_Workout_UpperBody
    case Icon_Workout_WholeBody
    
    // Activity tab - Stretch
    case Icon_Workout_BeforeSleep
    case Icon_Workout_LongSit
    case Icon_Workout_LongStand
    
    
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
