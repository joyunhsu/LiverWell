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
    @IBInspectable var lWBorderColor: UIColor? {
        
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
    @IBInspectable var lWBorderWidth: CGFloat {
        
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    //Corner radius
    @IBInspectable var lWCornerRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
        
    }
    
    // dropShadow
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // Round corner
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}






















