//
//  UIView+Extension.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/3.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    
    //Border Color
    @IBInspectable var lvBorderColor: UIColor? {
        
        get {
            guard let borderColor = layer.borderColor else {
                return nil
            }
            
            return UIColor(cgColor: borderColor)
            
        }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
        
    }
    
    //Border width
    @IBInspectable var lvBorderWidth: CGFloat {
        
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    //Corner radius
    @IBInspectable var lvCornerRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
        
    }
    
}






















