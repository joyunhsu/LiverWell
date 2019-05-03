//
//  Double+Extension.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/5/3.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation

extension Double {
    
    // swiftlint:disable identifier_name
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
}
