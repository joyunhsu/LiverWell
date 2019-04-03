//
//  UIImage+Extension.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/2.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    // Profile tab - Tab
    case Icons_36px_Home_Normal
    case Icons_36px_Home_Selected
    case Icons_36px_Profile_Normal
    case Icons_36px_Profile_Selected
    case Icons_36px_Cart_Normal
    case Icons_36px_Cart_Selected
    case Icons_36px_Catalog_Normal
    case Icons_36px_Catalog_Selected
    case Image_Logo02
    
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
    
    // Profile tab - Service
    case Icons_24px_Starred
    case Icons_24px_Notification
    case Icons_24px_Refunded
    case Icons_24px_Address
    case Icons_24px_CustomerService
    case Icons_24px_SystemFeedback
    case Icons_24px_RegisterCellphone
    case Icons_24px_Settings
    
    //Product page
    case Icons_24px_CollectionView
    case Icons_24px_ListView
    
    //Product size and color picker
    case Image_StrikeThrough
    
    //PlaceHolder
    case Image_Placeholder
    
    //Back button
    case Icons_24px_Back02
    
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
