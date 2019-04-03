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
    
    static var main: UIStoryboard { return lvStoryboard(name: StoryboardCategory.main) }
    
    static var home: UIStoryboard { return lvStoryboard(name: StoryboardCategory.home) }
    
    static var activity: UIStoryboard { return lvStoryboard(name: StoryboardCategory.activity) }
    
    static var knowledge: UIStoryboard { return lvStoryboard(name: StoryboardCategory.knowledge) }
    
    static var profile: UIStoryboard { return lvStoryboard(name: StoryboardCategory.profile) }
    
    private static func lvStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
        
    }
    
}
