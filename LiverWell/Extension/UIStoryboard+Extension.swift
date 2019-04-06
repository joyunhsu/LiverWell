//
//  UIStoryboard+Extension.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/3.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    
    static let home = "Home"
    
    static let activity = "Activity"
    
    static let knowledge = "Knowledge"
    
    static let profile = "Profile"
    
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return lWStoryboard(name: StoryboardCategory.main) }
    
    static var home: UIStoryboard { return lWStoryboard(name: StoryboardCategory.home) }
    
    static var activity: UIStoryboard { return lWStoryboard(name: StoryboardCategory.activity) }
    
    static var knowledge: UIStoryboard { return lWStoryboard(name: StoryboardCategory.knowledge) }
    
    static var profile: UIStoryboard { return lWStoryboard(name: StoryboardCategory.profile) }
    
    private static func lWStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
        
    }
    
}
