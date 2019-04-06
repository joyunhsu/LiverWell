//
//  HomeManager.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/3.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

class HomeManager {
    
    let restingGroup = HomeGroup(
        title: "休息中",
        items: [
            RestingItem.watchTV,
            RestingItem.preventBackPain,
            RestingItem.wholeBody,
            RestingItem.upperBody,
            RestingItem.lowerBody
        ]
    )
    
    let workingGroup = HomeGroup(title: "工作中", items: [
            WorkingItem.longSit,
            WorkingItem.longStand
        ]
    )
    
    let beforeSleepGroup = HomeGroup(
        title: "準備就寢",
        items: [
            SleepItem.beforeSleep
        ]
    )
    
    lazy var groups: [HomeGroup] = [workingGroup, restingGroup, beforeSleepGroup]
    
}



















