//
//  UIColor+Extension.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/6.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

private enum LWColor: String {

    // swiftlint:disable identifier_name
    case Orange
    
    case Yellow

    case G1
    
    case G2

    case B1

    case B3

    case B5
}

extension UIColor {

    static let Orange = LWColor(.Orange)
    
    static let Yellow = LWColor(.Yellow)

    static let G1 = LWColor(.G1)
    
    static let G2 = LWColor(.G2)

    static let B1 = LWColor(.B1)

    static let B3 = LWColor(.B3)

    static let B5 = LWColor(.B5)

    private static func LWColor(_ color: LWColor) -> UIColor? {

        return UIColor(named: color.rawValue)
    }

    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
