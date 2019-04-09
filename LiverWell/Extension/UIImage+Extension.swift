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
    // swiftlint:disable identifier_name
    case Icon_24px_Home_Normal
    case Icon_24px_Home_Selected
    case Icon_24px_Workout_Normal
    case Icon_24px_Workout_Selected
    case Icon_24px_Knowledge_Normal
    case Icon_24px_Knowledge_Selected
    case Icon_24px_Profile_Normal
    case Icon_24px_Profile_Selected

    // Home tab - Resting
    case Icon_Home_BackPain
    case Icon_Home_LowerBody
    case Icon_Home_UpperBody
    case Icon_Home_WatchTV
    case Icon_Home_WholeBody

    // Home tab - Working
    case Icon_Home_LongSit
    case Icon_Home_LongStand

    // Home tab - Before Sleep
    case Icon_Home_BeforeSleep

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

    // swiftlint:enable identifier_name
}

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
