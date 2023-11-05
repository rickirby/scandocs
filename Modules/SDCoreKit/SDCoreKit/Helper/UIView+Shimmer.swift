//
//  UIView+Shimmer.swift
//  SDCoreKit
//
//  Created by Ricki Bin Yamin on 10/10/23.
//

import UIKit

public extension UIView {
    func startShimmering(){
        self.layoutIfNeeded()
        self.backgroundColor = .lightGray
        let light = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.5).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.25, 0.5, 0.75]
        layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 0.3
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering(){
        backgroundColor = .clear
        layer.mask = nil
    }
}
