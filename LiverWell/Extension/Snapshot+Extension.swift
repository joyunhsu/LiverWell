//
//  Snapshot+Extension.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/5/7.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

extension DocumentSnapshot {
    
    func decode<T: Decodable>(as objectType: T.Type, data: [String: Any]? = nil, includingId: Bool = true) throws -> T {
        
        var documentJson: [String: Any]?
        
        if data != nil {
            documentJson = data
        } else {
            documentJson = self.data()
        }
        
//        if includingId {
//            documentJson!["id"] = documentID
//        }
        
        let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
        let decodeObject = try JSONDecoder().decode(objectType, from: documentData)
        
        return decodeObject
        
    }
    
}
