//
//  HomeItem.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/3.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

protocol HomeItem {
    
    var image: UIImage? { get }
    
//    var title: String { get }
    
}

struct HomeGroup {
    
    let title: String
    
    let items: [HomeItem]
    
}

enum RestingItem: HomeItem {
    
    case watchTV
    
    case preventBackPain
    
    case wholeBody
    
    case upperBody
    
    case lowerBody
    
    var image: UIImage? {
        
        switch self {

        case .watchTV: return UIImage.asset(.Icon_Home_WatchTV)
            
        case .preventBackPain: return UIImage.asset(.Icon_Home_BackPain)
            
        case .wholeBody: return UIImage.asset(.Icon_Home_WholeBody)
            
        case .upperBody: return UIImage.asset(.Icon_Home_UpperBody)
            
        case .lowerBody: return UIImage.asset(.Icon_Home_LowerBody)
            
        }
    }
}

enum WorkingItem: HomeItem {
    
    case longSit
    
    case longStand
    
    var image: UIImage? {
        
        switch self {
            
        case .longSit: return UIImage.asset(.Icon_Home_LongSit)
            
        case .longStand: return UIImage.asset(.Icon_Home_LongStand)
            
        }
    }
}

enum SleepItem: HomeItem {
    
    case beforeSleep
    
    var image: UIImage? {
        
        switch self {
            
        case .beforeSleep: return UIImage.asset(.Icon_Home_BeforeSleep)
        }
        
    }
    
}











