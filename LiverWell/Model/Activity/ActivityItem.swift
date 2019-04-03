//
//  ActivityItem.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/3.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

struct ActivityGroup {
    
    let titleLine1: String
    
    let titleLine2: String
    
    let caption: String
    
    let items: [ActivityItem]
}

protocol ActivityItem {
    
    var image: UIImage? { get }
    
    var title: String { get }
    
}

enum TrainItem: ActivityItem {
    
    case watchTV
    
    case preventBackPain
    
    case wholeBody
    
    case upperBody
    
    case lowerBody
    
    var image: UIImage? {
        
        switch self {
            
        case .watchTV: return UIImage.asset(.Icon_Workout_TV)
            
        case .preventBackPain: return UIImage.asset(.Icon_Workout_BackPain)
            
        case .wholeBody: return UIImage.asset(.Icon_Workout_WholeBody)
            
        case .upperBody: return UIImage.asset(.Icon_Workout_UpperBody)
            
        case .lowerBody: return UIImage.asset(.Icon_Workout_LowerBody)
            
        }
    }
    
    var title: String {
        
        switch self {
            
        case .watchTV: return "看電視順便做"
            
        case .preventBackPain: return "預防腰痛"
            
        case .wholeBody: return "全身訓練"
            
        case .upperBody: return "上半身訓練"
            
        case .lowerBody: return "下半身訓練"
            
        }
        
    }
}

enum StretchItem: ActivityItem {
    
    case longSit
    
    case longStand
    
    case beforeSleep
    
    var image: UIImage? {
        
        switch self {
            
        case .longSit: return UIImage.asset(.Icon_Workout_LongSit)
            
        case .longStand: return UIImage.asset(.Icon_Workout_LongStand)
            
        case .beforeSleep: return UIImage.asset(.Icon_Workout_BeforeSleep)
            
        }
        
    }
    
    var title: String {
        
        switch self {
            
        case .longSit: return "久坐伸展"
            
        case .longStand: return "久站伸展"
            
        case .beforeSleep: return "睡前舒緩"
            
        }
        
    }
    
}




