//
//  WeightProvider.swift
//  LiverWell
//
//  Created by Jo Yun Hsu on 2019/5/14.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation
import Firebase

struct WeightStatus {
    
    let signupTime: String
    
    let expectWeight: Double
    
    let weightSinceStart: Double
    
    let weightSinceMonth: Double
    
}

class WeightProvider {
    
    let userDefaults = UserDefaults.standard
    
    let startOfMonth = Date().startOfMonth()
    
    var signupTime = ""
    var expectedWeight: Double = 0
    var initialWeight: Double = 0
    var lastMonthWeight: Double = 0
    var currentWeight: Double = 0
    var user: UserItem?
    
    func getStatus() -> WeightStatus {
        
        getUserData()

        getLastMonthWeight()

        getThisMonthWeight()
        
        let weightSinceStart = currentWeight - initialWeight
        
        let weightSinceMonth = currentWeight - lastMonthWeight
        
        let weightStatus = WeightStatus(
            signupTime: signupTime,
            expectWeight: expectedWeight,
            weightSinceStart: weightSinceStart,
            weightSinceMonth: weightSinceMonth)
        
        return weightStatus
    
    }
    
    private func getUserData() {
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let userDocRef = AppDelegate.db.collection("users").document(uid)
        
        userDocRef
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    guard let initial = document.get("initial_weight") as? Double else { return }
                    guard let expected = document.get("expected_weight") as? Double else { return }
                    guard let signupTime = document.get("signup_time") as? Timestamp else { return }
                    
//                    self.startMonthLabel.text = DateFormatter.chineseYearMonth(date: signupTime.dateValue())
//                    self.expectedWeightLabel.text = String(expected)
                    
                    self.initialWeight = initial
                    self.expectedWeight = expected
                    self.signupTime = DateFormatter.chineseYearMonth(date: signupTime.dateValue())
                    
//                    let user = UserItem(name: "", signupTime: signupTime.dateValue(), expectedWeight: expected, initialWeight: initial)
//
//                    self.user = user
                    
                } else {
                    
                    print("Document does not exist: \(String(describing: error))")
                    
                }
        }
        
    }
    
    private func getLastMonthWeight() {
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let weightRef = AppDelegate.db.collection("users").document(uid).collection("weight")
        
        weightRef
            .whereField("created_time", isLessThan: startOfMonth)
            .order(by: "created_time", descending: true)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                } else {
                    for document in snapshot!.documents {
                        
                        guard let weight = document.get("weight") as? Double else { return }
                        
                        self.lastMonthWeight = weight
                        
                    }
                }
        }
        
    }
    
    private func getThisMonthWeight() {
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let weightRef = AppDelegate.db.collection("users").document(uid).collection("weight")
        
        weightRef
            .whereField("created_time", isGreaterThan: startOfMonth)
            .order(by: "created_time", descending: true)
            .limit(to: 1)
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                } else {
                    for document in snapshot!.documents {
                        
//                        guard let createdTime = document.get("created_time") as? Timestamp else { return }
                        guard let currentWeight = document.get("weight") as? Double else { return }
                        
//                        let convertedDate = DateFormatter.chineseYearMonth(date: createdTime.dateValue())
//                        self?.currentMonthLabel.text = convertedDate
                        self?.currentWeight = currentWeight
                    }
                    
                }
        }
        
    }
    
}
