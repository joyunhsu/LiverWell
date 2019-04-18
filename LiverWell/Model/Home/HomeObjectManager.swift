//
//  HomeObjectManager.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/18.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation

class HomeObjectManager {
    
    let decoder = JSONDecoder()
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getHomeObject(
        homeStatus: HomeStatus,
        completionHandler completion: @escaping (HomeObject?, Error?
        ) -> Void) {
        
        guard let url = URL(
            string: "https://liver-well.firebaseio.com/homeVC/\(homeStatus.url()).json"
            ) else { return }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                
                do {
                    let homeObject: HomeObject = try self.decoder.decode(
                        HomeObject.self,
                        from: data)
                    print(homeObject)
                    completion(homeObject, nil)
                    
                } catch {
                    
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
}
