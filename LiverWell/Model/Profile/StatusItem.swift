//
//  statusItem.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/25.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation

struct WorkoutData {
    let convertedDate: String
    let timestampToDate: Date
    let workoutTime: Int
    let title: String
    let activityType: String
}

struct ActivityEntry {
    let title: String
    let time: Int
    let activityType: String
}
