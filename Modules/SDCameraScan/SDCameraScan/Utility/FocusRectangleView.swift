//
//  FocusRectangleView.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 29/10/23.
//

import UIKit

class FocusRectangleView: UIView {
    convenience init(touchPoint: CGPoint) {
        let originalSize: CGFloat = 200
        let finalSize: CGFloat = 80
        
        self.init(frame: CGRect(x: touchPoint.x - (originalSize / 2), y: touchPoint.y - (originalSize / 2), width: originalSize, height: originalSize))
        
        backgroundColor = .clear
        layer.borderWidth = 2.0
        layer.cornerRadius = 0.0
        layer.borderColor = UIColor.yellow.cgColor
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.frame.origin.x += (originalSize - finalSize) / 2
            self.frame.origin.y += (originalSize - finalSize) / 2
            
            self.frame.size.width -= (originalSize - finalSize)
            self.frame.size.height -= (originalSize - finalSize)
        })
    }
}
