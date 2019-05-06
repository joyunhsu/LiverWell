//
//  Int+Extension.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/5/6.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}
