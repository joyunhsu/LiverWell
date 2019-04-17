//
//  WorkoutManager.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/16.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation

class WorkoutManager {
    
    let decoder = JSONDecoder()
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }

    func getWorkout(activity: ActivityItems, completionHandler completion: @escaping (Train?, Error?) -> Void) {
    
        guard let url = URL(string: "https://liver-well.firebaseio.com/activityVC/\(activity.url())/workout.json") else { return }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                
                do {
                    let train: Train = try self.decoder.decode(Train.self, from: data)
                    print(train[0])
                    
                    completion(train, nil)
                    
                } catch {
                    
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
}

typealias Train = [TrainElement]

struct TrainElement: Codable {
    let description, icon, id, title: String
    let workoutSet: [String: WorkoutSet]
}

struct WorkoutSet: Codable {
    let count: Int
    let description: String
    let workoutSetImage: [String]?
    let perDuration, workoutSetRepeat: Int
    let annotation: [String]?
    let image: [String]?
    
    enum CodingKeys: String, CodingKey {
        case count, description
        case workoutSetImage = "image"
        case perDuration
        case workoutSetRepeat = "repeat"
        case annotation
        case image = "Image"
    }
}

enum ActivityItems {
    case train
    case stretch
    func url() -> String {
        switch self {
        case .train: return "0/train/"
        case .stretch: return "1/stretch"
        }
    }
}

enum TrainItems {
    case watchTV
    case backPain
    case wholeBody
    case upperBody
    case lowerBody
    func toIndex() -> Int {
        switch self {
        case .watchTV: return 0
        case .backPain: return 1
        case .wholeBody: return 2
        case .upperBody: return 3
        case .lowerBody: return 4
        }
    }
}
