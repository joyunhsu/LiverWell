//
//  HomeManager.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/3.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//
import Foundation
import Firebase

struct WorkOut: Codable {
    
    var workOutTime: Int
    
    var activityType: String
    
    var createdTime: Timestamp?

    enum CodingKeys: String, CodingKey {
        
        case workOutTime = "workout_time"
        
        case activityType = "activity_type"
        
//        case createdTime = "created_time"
    }
}

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
    
    var monSum = 0
    var tueSum = 0
    var wedSum = 0
    var thuSum = 0
    var friSum = 0
    var satSum = 0
    var sunSum = 0
    
    var dailyValue: [Int] {
        return [monSum, tueSum, wedSum, thuSum, friSum, satSum, sunSum]
    }
    
    var todayTrainTime: Int = 0
    
    var todayStretchTime: Int = 0

    lazy var groups: [HomeGroup] = [workingGroup, restingGroup, beforeSleepGroup]
    
    func getThisWeekProgress(today: Date, completion: @escaping (Result<[Int], Error>) -> Void) {
        
        let userDefaults = UserDefaults.standard
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let today = today
        
        let workoutRef = AppDelegate.db.collection("users").document(uid).collection("workout")
        
        print("ya")
        
        workoutRef
            .whereField("created_time", isGreaterThan: today.dayOf(.monday))
            .order(by: "created_time", descending: false)
            .getDocuments { (snapshot, error) in
                
                print("jo")
                
                if let error = error {
                
                    print("Error getting documents: \(error)")
                
                } else {
                    
                    var workouts: [WorkOut?] = []
                    
                    for document in snapshot!.documents {
                        
                        let createdTime = document.get("created_time") as? Timestamp
                        
                        var data = document.data()
                        
                        data.removeValue(forKey: "created_time")
                        
                        var item = try? document.decode(as: WorkOut.self, data: data)
                        
                        item?.createdTime = createdTime
                        
                        workouts.append(item)
                        
//                        if let createdTime = document.get("created_time") as? Timestamp {
//
//                        } else {
//                            continue
//                        }
//                        let date = createdTime.dateValue()
//
//                        self?.sortBy(day: date, workoutType: activityType, workoutTime: workoutTime)
                    }
                    
                    let nonnilWorkouts = workouts.compactMap({ $0 })
                    
                    for item in nonnilWorkouts {
                        
                        if let time = item.createdTime?.dateValue() {
                            
                            self.sortBy(day: time, workoutType: item.activityType, workoutTime: item.workOutTime)
                        }
                    }
                    
                    completion(Result.success(self.dailyValue))
                }
                
        }
    }
    
    private func sortBy(day date: Date, workoutType: String, workoutTime: Int) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.string(from: date)
        
        let today = Date()
        
        if convertedDate == dateFormatter.string(from: today) && workoutType == "train" {
            
            self.todayTrainTime += workoutTime
            
        } else if convertedDate == dateFormatter.string(from: today) && workoutType == "stretch" {
            
            self.todayStretchTime += workoutTime
            
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.monday)) {
            self.monSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.tuesday)) {
            self.tueSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.wednesday)) {
            self.wedSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.thursday)) {
            self.thuSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.friday)) {
            self.friSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.saturday)) {
            self.satSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.sunday)) {
            self.sunSum += workoutTime
        }
        
    }
    
    func reset() {
        
        todayTrainTime = 0
        
        todayStretchTime = 0
        
        monSum = 0
        tueSum = 0
        wedSum = 0
        thuSum = 0
        friSum = 0
        satSum = 0
        sunSum = 0
    }

}
