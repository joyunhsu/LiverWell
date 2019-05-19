//
//  StatusManager.swift
//  LiverWell
//
//  Created by Jo Yun Hsu on 2019/5/13.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation
import Firebase

class StatusProvider {
    
    // swiftlint:disable identifier_name
    var watchTVSum = 0
    var backPainSum = 0
    var wholeBodySum = 0
    var upperBodySum = 0
    var lowerBodySum = 0
    var longSitSum = 0
    var longStandSum = 0
    var beforeSleepSum = 0
    
    var monSum = [0, 0] // [train, stretch]
    var tueSum = [0, 0]
    var wedSum = [0, 0]
    var thuSum = [0, 0]
    var friSum = [0, 0]
    var satSum = [0, 0]
    var sunSum = [0, 0]
    var weekSum: [[Int]] {
        return [monSum, tueSum, wedSum, thuSum, friSum, satSum, sunSum]
    }
    
    var stretchTimeSum = 0
    var trainTimeSum = 0
    var workoutDataArray = [WorkoutData]()

    func getWeeklyWorkout(weeksBefore: Int, completion: @escaping (Result<[WorkoutData], Error>) -> Void) {
        
        reset()
        
        guard let user = Auth.auth().currentUser else { return }
        
        let workoutRef = AppDelegate.db.collection("users").document(user.uid).collection("workout")
        
        let today = Date()
        
        guard let referenceDay = Calendar.current.date(
            byAdding: .day,
            value: 0 + 7 * weeksBefore,
            to: today) else { return }
        
        let monday = referenceDay.dayOf(.monday)
        
        let sunday = referenceDay.dayOf(.sunday)
        
        workoutRef
            .whereField("created_time", isLessThan: Calendar.current.date(byAdding: .day, value: 1, to: sunday)!)
            .whereField("created_time", isGreaterThan: monday)
            .order(by: "created_time", descending: false) // 由舊到新
            .getDocuments { [weak self] (snapshot, error) in
                
                if let error = error {
                    print("Error getting document: \(error)")
                } else {
                    for document in snapshot!.documents {
                        
                        guard let createdTime = document.get("created_time") as? Timestamp else { return }
                        
                        var json = document.data()
                        
                        json["created_time"] = nil
                        
                        var item = try? document.decode(as: WorkoutData.self, data: json)
                        
                        item?.timestampToDate = createdTime.dateValue()
                        
                        self?.workoutDataArray.append(item!)
                        
                    }
                    
                    for _ in self!.workoutDataArray {
                            
                        self?.sortByTitle()
                        
                        self?.sortByType()
                        
                        self?.sortByDayAndType(weeksBefore: weeksBefore)
                    
                    }
                    
                    completion(Result.success(self!.workoutDataArray))
                }
                
        }
        
    }
    
    private func sortByTitle() {
        
        self.watchTVSum = getWorkoutSumBy(title: TrainItem.watchTV.title)
        
        self.backPainSum = getWorkoutSumBy(title: TrainItem.preventBackPain.title)
        
        self.wholeBodySum = getWorkoutSumBy(title: TrainItem.wholeBody.title)
        
        self.upperBodySum = getWorkoutSumBy(title: TrainItem.upperBody.title)
        
        self.lowerBodySum = getWorkoutSumBy(title: TrainItem.lowerBody.title)
        
        self.longSitSum = getWorkoutSumBy(title: StretchItem.longSit.title)
        
        self.longStandSum = getWorkoutSumBy(title: StretchItem.longStand.title)
        
        self.beforeSleepSum = getWorkoutSumBy(title: StretchItem.beforeSleep.title)
    }
    
    private func sortByType() {
        
        self.trainTimeSum = getWorkoutSumBy(type: ActivityType.train.rawValue)
        
        self.stretchTimeSum = getWorkoutSumBy(type: ActivityType.stretch.rawValue)
        
    }
    
    private func sortByDayAndType(weeksBefore: Int) {
        
        let today = Date()
        
        guard let referenceDay = Calendar.current.date(
            byAdding: .day,
            value: 0 + 7 * weeksBefore,
            to: today) else { return }
        
        self.monSum = filterByDayAndType(day: referenceDay.dayOf(.monday))
        
        self.tueSum = filterByDayAndType(day: referenceDay.dayOf(.tuesday))
        
        self.wedSum = filterByDayAndType(day: referenceDay.dayOf(.wednesday))
        
        self.thuSum = filterByDayAndType(day: referenceDay.dayOf(.thursday))
        
        self.friSum = filterByDayAndType(day: referenceDay.dayOf(.friday))
        
        self.satSum = filterByDayAndType(day: referenceDay.dayOf(.saturday))
        
        self.sunSum = filterByDayAndType(day: referenceDay.dayOf(.sunday))
        
    }
    
    private func filterByDayAndType(day: Date) -> [Int] {
        
        let convertedDate = DateFormatter.yearMonthDay(date: day)
        
        let dayTrain = workoutDataArray.filter({
            
            $0.convertedDate == convertedDate && $0.activityType == ActivityType.train.rawValue
            
        })
        
        let dayStretch = workoutDataArray.filter({
            
            $0.convertedDate == convertedDate && $0.activityType == ActivityType.stretch.rawValue
            
        })
        
        return [timeSumOf(array: dayTrain), timeSumOf(array: dayStretch)]
        
    }
    
    private func getWorkoutSumBy(type: String) -> Int {
        
        let array = self.workoutDataArray.filter({
            
            $0.activityType == type
            
        })
        
        return timeSumOf(array: array)
    }
    
    private func getWorkoutSumBy(title: String) -> Int {
        
        let array = self.workoutDataArray.filter({
            
            $0.title == title
            
        })
        
        return timeSumOf(array: array)
    }
    
    private func percentageOf(entry sum: Int) -> Int {
        
        let totalSum = stretchTimeSum + trainTimeSum
        
        let percentage = lround(Double(sum * 100 / totalSum))
        
        return percentage
        
    }
    
    private func timeSumOf(array: [WorkoutData]) -> Int {
        
        var timeArray = [Int]()
        
        for i in 0..<array.count {
            
            timeArray.append(array[i].workoutTime)
            
        }
        
        let timeSum = timeArray.reduce(0, +)
        
        return timeSum
        
    }
    
    func reset() {
        
        workoutDataArray = [WorkoutData]()
        
        monSum = [0, 0]
        tueSum = [0, 0]
        wedSum = [0, 0]
        thuSum = [0, 0]
        friSum = [0, 0]
        satSum = [0, 0]
        sunSum = [0, 0]
    }
    
}
