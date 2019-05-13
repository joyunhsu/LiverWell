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
        
    }
}

class HomeManager {
    
    let now = Date()
    
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
    
    func getThisWeekProgress(today: Date, completion: @escaping (Result<[Int], Error>) -> Void) {
        
        let userDefaults = UserDefaults.standard
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let today = today
        
        let workoutRef = AppDelegate.db.collection("users").document(uid).collection("workout")
        
        workoutRef
            .whereField("created_time", isGreaterThan: today.dayOf(.monday))
            .order(by: "created_time", descending: false)
            .getDocuments { (snapshot, error) in
                
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
    
    func determineStatus(workStartHour: Int, workEndHour: Int) -> (HomeStatus, String) {
        
        let sunday = now.dayOf(.sunday)
        let saturday = now.dayOf(.saturday)
        
        let workStart = now.dateAt(hours: workStartHour, minutes: 0)
        let workEnd = now.dateAt(hours: workEndHour, minutes: 0)
        let sleepStart = now.dateAt(hours: 21, minutes: 30)
        let sleepEnd = now.dateAt(hours: 5, minutes: 0)
        let nowHour = Calendar.current.component(.hour, from: now)
        
        if now >= saturday && now <= Calendar.current.date(byAdding: .day, value: 1, to: sunday)! {
            
            // weekend
            if now >= sleepEnd && now <= sleepStart {
                
                return (.resting, "休息日好好放鬆，起身動一動！")
                
            } else {
                
                return (.beforeSleep, "休息日好好放鬆，起身動一動！")
            }
            
        } else {
            
            // workday
            let fromRestHour = workEndHour - nowHour
            
            if now >= workStart && now <= workEnd {
                
                return (.working, "離休息時間還有 \(fromRestHour) 小時")
                
            } else if now >= workEnd && now <= sleepStart {
                
                return (.resting, "離工作時間還有 \((24 - nowHour) + workStartHour) 小時")
                
            } else if now >= sleepEnd && now <= workStart {
                
                return (.resting, "離工作時間還有 \(workStartHour - nowHour) 小時")
                
            } else {
                
                if nowHour > workEndHour {
                    
                    return (.beforeSleep, "離工作時間還有 \((24 - nowHour) + workStartHour) 小時")
                    
                } else if nowHour < workStartHour {
                    
                    return (.beforeSleep, "離工作時間還有 \(workStartHour - nowHour) 小時")
                    
                } else {
                    
                    return (.beforeSleep, "")
                }
            }
        }
    }

}
