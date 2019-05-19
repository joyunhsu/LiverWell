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
    
    let dispatchGroup = DispatchGroup()
    
    let startOfMonth = Date().startOfMonth()
    
    var weightDataArray = [WeightData]()
    
    var signupTime = ""
    
    var expectedWeight: Double = 0
    
    var initialWeight: Double = 0
    
    var lastMonthWeight: Double = 0
    
    var currentWeight: Double = 0
    
    func getStatus(completion: @escaping (WeightStatus) -> Void) {
        
        getUserData()

        getLastMonthWeight()

        getThisMonthWeight()
        
        dispatchGroup.notify(queue: .main) {
            
            let weightSinceStart = self.currentWeight - self.initialWeight
            
            let weightSinceMonth = self.currentWeight - self.lastMonthWeight
            
            let weightStatus = WeightStatus(
                signupTime: self.signupTime,
                expectWeight: self.expectedWeight,
                weightSinceStart: weightSinceStart,
                weightSinceMonth: weightSinceMonth)
            
            completion(weightStatus)
        }

    }
    
    private func getUserData() {
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let userDocRef = AppDelegate.db.collection("users").document(uid)
        
        dispatchGroup.enter()
        
        userDocRef
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    guard let initial = document.get("initial_weight") as? Double else { return }
                    guard let expected = document.get("expected_weight") as? Double else { return }
                    guard let signupTime = document.get("signup_time") as? Timestamp else { return }
                    
                    self.initialWeight = initial
                    self.expectedWeight = expected
                    self.signupTime = DateFormatter.chineseYearMonth(date: signupTime.dateValue())
                    
                    self.dispatchGroup.leave()
                    
                } else {
                    
                    print("Document does not exist: \(String(describing: error))")
                }
                
        }
    
    }
    
    private func getLastMonthWeight() {
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let weightRef = AppDelegate.db.collection("users").document(uid).collection("weight")
        
        dispatchGroup.enter()
        
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
                    
                    self.dispatchGroup.leave()
                }
        }
        
    }
    
    private func getThisMonthWeight() {
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let weightRef = AppDelegate.db.collection("users").document(uid).collection("weight")
        
        dispatchGroup.enter()
        
        weightRef
            .whereField("created_time", isGreaterThan: startOfMonth)
            .order(by: "created_time", descending: true)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                } else {
                    for document in snapshot!.documents {
                        
                        guard let current = document.get("weight") as? Double else { return }
                        self.currentWeight = current
                    }
                    
                    self.dispatchGroup.leave()
                }
        }
        
    }
    
    func getWeight(completion: @escaping (Result<[WeightData], Error>) -> Void) {
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let weightRef = AppDelegate.db.collection("users").document(uid).collection("weight")
        
        weightRef
            .order(by: "created_time", descending: true) // 由新到舊
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    
                    guard let strongSelf = self else { return }
                    
                    for document in snapshot!.documents {
                        
                        guard let createdTime = document.get("created_time") as? Timestamp else { return }
                        
                        var json = document.data()
                        
                        json["created_time"] = nil
                        
                        var item = try? document.decode(as: WeightData.self, data: json)
                        
                        item?.createdTime = createdTime.dateValue()
                        
                        item?.documentID = document.documentID
                        
                        strongSelf.weightDataArray.append(item!)
                    }
                    
                    completion(Result.success(strongSelf.weightDataArray))
                }
        }
    }
}
