//
//  HomeViewModel.swift
//  LiverWell
//
//  Created by Jo Yun Hsu on 2019/5/14.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation
import MKProgress

protocol HomeManagerDelegate: AnyObject {
    
    func didGet(date: String, homeObject: HomeObject, description: String)
    
    func didGet(todayTrainTime: Int, todayStretchTime: Int)
}

class HomeManager {
    
    let homeProvider = HomeProvider()
    
    let homeObjectManager = HomeObjectManager()
    
    var homeObject: HomeObject?
    
    let dispatchGroup = DispatchGroup()
    
    var statusDescription: String?
    
    var trainWorkoutTime: Int {
        
        return homeProvider.todayTrainTime
    }
    
    var stretchWorkoutTime: Int {
        
        return homeProvider.todayStretchTime
    }
    
    var dailyValue: [Int] {
        
        return homeProvider.dailyValue
    }
    
    weak var delegate: HomeManagerDelegate?
    
    func activate() {
        
        getThisWeekProgess()
        
        getStatus(workStartHour: 9, workEndHour: 18)
        
        groupNofity()
    }
    
    private func getThisWeekProgess() {
        
        dispatchGroup.enter()
        
        homeProvider.getThisWeekProgress(today: Date()) { (result) in
            
            switch result {
                
            case .success(let workOuts):
                
                print(workOuts)
                
            case .failure(let error):
                
                print(error)
            }
            
            self.dispatchGroup.leave()
        }
        
    }
    
    func getStatus(workStartHour: Int, workEndHour: Int) {
        
        let statusElement = homeProvider.determineStatusAt(workStartHour: workStartHour, workEndHour: workEndHour)
        
        statusDescription = statusElement.description
        
        dispatchGroup.enter()
        
        homeObjectManager.getHomeObject(homeStatus: statusElement.status) { [weak self] (homeObject, _ ) in
            
            self?.homeObject = homeObject
            
            self?.dispatchGroup.leave()
        }
    }
    
    private func today() -> String {
        
        let chineseMonthDate = DateFormatter.chineseMonthDate(date: Date())
        
        let chineseDay = DateFormatter.chineseWeekday(date: Date())
        
        return "\(chineseMonthDate) \(chineseDay)"
        
    }
    
    private func groupNofity() {
        
        dispatchGroup.notify(queue: .main) { [weak self] in

            guard let strongSelf = self,
                  let homeObject = strongSelf.homeObject,
                  let description = strongSelf.statusDescription
            else { return }
            
            let todayTrainTime = strongSelf.homeProvider.todayTrainTime
            
            let todayStretchTime = strongSelf.homeProvider.todayStretchTime

            strongSelf.delegate?.didGet(date: strongSelf.today(), homeObject: homeObject, description: description)
            
            strongSelf.delegate?.didGet(todayTrainTime: todayTrainTime, todayStretchTime: todayStretchTime)
            
            ProgressHud.hideProgressHud()
        }
    }
    
    func reset() {
        
        homeProvider.reset()
    }

}
