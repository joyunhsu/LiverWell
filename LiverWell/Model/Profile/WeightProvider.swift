//
//  WeightProvider.swift
//  LiverWell
//
//  Created by Jo Yun Hsu on 2019/5/14.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation
import Firebase



class WeightProvider {
    
    let userDefaults = UserDefaults.standard
    
    let startOfMonth = Date().startOfMonth()
    
    var initialWeight: Double = 0
    var lastMonthWeight: Double = 0
//    var currentWeight: Double = 0
    
    private func readStatus() {
        
//        getUserData()
//
//        getLastMonthWeight()
//
//        getThisMonthWeight()
        
    }
    
    private func getUserData(completion: @escaping (Result<UserItem, Error>) -> Void) {
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let userDocRef = AppDelegate.db.collection("users").document(uid)
        
        userDocRef
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    guard let initial = document.get("initial_weight") as? Double else { return }
                    guard let expected = document.get("expected_weight") as? Double else { return }
                    guard let signupTime = document.get("signup_time") as? Timestamp else { return }
                    
//                    let convertedDate = DateFormatter.chineseYearMonth(date: signupTime.dateValue())
//                    self.startMonthLabel.text = convertedDate
//                    self.expectedWeightLabel.text = String(expected)
                    self.initialWeight = initial
                    
                    let user = UserItem(name: "", signupTime: signupTime.dateValue(), expectedWeight: expected, initialWeight: initial)
                    
                    completion(Result.success(user))
                    
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
//                        self?.currentWeight = weight
                        
                        let weightSinceStart = currentWeight - self!.initialWeight
                        
//                        if weightSinceStart > 0 {
//                            self?.weightSinceStartLabel.text = "+\(weightSinceStart.format(f: ".1"))"
//                        } else {
//                            self?.weightSinceStartLabel.text = weightSinceStart.format(f: ".1")
//                        }
                        
                        let weightSinceMonth = currentWeight - self!.lastMonthWeight
                        
//                        if weightSinceMonth > 0 {
//                            self?.weightSinceMonthLabel.text = "+\(weightSinceMonth.format(f: ".1"))"
//                            self?.progressView.progress = 0
//                            self?.progressLabel.text = "0%"
//                        } else {
//                            self?.weightSinceMonthLabel.text = weightSinceMonth.format(f: ".1")
//                            self?.progressView.progress = Float((0 - weightSinceMonth) / 1)
//                            self?.progressLabel.text = "\(Int(Float((0 - weightSinceMonth) / 1) * 100))%"
//                        }

                    }
                    
                }
        }
        
    }
    
}
