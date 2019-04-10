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
    
    @IBInspectable var lWShadowColor: UIColor? {
        
        get {
            
            guard let shadowColor = layer.shadowColor else {
                return nil
            }
            
            return UIColor(cgColor: shadowColor)
        }
        
        set {
            layer.shadowColor = newValue?.cgColor
        }
        
    }
    
    @IBInspectable var lWShadowOpacity: Float {
        
        get {
            
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
        }
        
    }
    
    @IBInspectable var lWShadowOffset: CGSize {
        
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var lWshadowRadius: CGFloat {
        
        get {
            return layer.shadowRadius
        }
        
        set {
            return layer.shadowRadius = newValue
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
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    // Rotate
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }

}
