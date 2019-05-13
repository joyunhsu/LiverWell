//
//  statusItem.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/25.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation
import Firebase

struct WorkoutData: Codable {
    
    var convertedDate: String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = timestampToDate else { return "" }
        
        let convertedDate = dateFormatter.string(from: date)
        
        return convertedDate
    }
    
    var timestampToDate: Date?
    
    let workoutTime: Int
    
    let title: String
    
    let activityType: String
    
    enum CodingKeys: String, CodingKey {
//        case convertedDate = "converted_date"
//        case timestampToDate = "created_time"
        case workoutTime = "workout_time"
        case activityType = "activity_type"
        case title
    }
}

struct ActivityEntry {
    let title: String
    let time: Int
    let activityType: String
}

