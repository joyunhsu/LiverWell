//
//  FirebaseManager.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/16.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    func addSignupListener(listener: @escaping (Bool) -> Void) {
        
    }
    
    var luke: (() -> Void)?
    
    func escapingSample(sample: @escaping () -> Void) {
        
        self.luke = sample
        
    }
    
    func runClosrue() {
//        self.luke?()
        
        var abcd = 10
        
        self.luke = {
            abcd += 10
            print(abcd)
        }
    }
    
    // Capture: closure 會抓住所有他用到的東西，Closure是物件的概念，只要Closure活著就會去Retain他的東西。
    
}
