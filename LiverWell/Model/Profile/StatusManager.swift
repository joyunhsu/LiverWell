//
//  StatusManager.swift
//  LiverWell
//
//  Created by Jo Yun Hsu on 2019/5/13.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation
import Firebase

class StatusManager {
    
    func getWeeklyWorkout(weeksBefore: Int) {
        
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
            .getDocuments { (snapshot, error) in
                
                if let error = error {
                    print("Error getting document: \(error)")
                } else {
                    for document in snapshot!.documents {
                        
                        guard let createdTime = document.get("created_time") as? Timestamp else { return }
                        
                        var json = document.data()
                        
                        json["created_time"] = nil
                        
                        var item = try? document.decode(as: WorkoutData.self, data: json)
                        
                        item?.timestampToDate = createdTime.dateValue()
                        
//                        self?.workoutDataArray.append(item!)
                        
                    }
                }
                
//                self?.sortByTitle()
//
//                self?.sortByType()
//
//                self?.sortByDayAndType(weeksBefore: weeksBefore)
//
//                self?.setupActivityEntry()
//
//                self?.setChartData(count: 7, range: 60)
//
//                self?.barChartViewSetup()
//
//                self?.chartView.animate(yAxisDuration: 0.5)
                
        }
        
    }
    
    private func sortByTitle() {
        
    }
    
    private func sortByType() {
        
    }
    
    private func sortByDayAndType(weeksBefore: Int) {
        
    }
    
    
    
}
