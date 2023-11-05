//
//  Transformable.swift
//  SDScanKit
//
//  Created by Ricki Bin Yamin on 24/10/23.
//

import UIKit

public protocol Transformable {
    func applying(_ transform: CGAffineTransform) -> Self
}

public extension Transformable {
    func applyTransforms(_ transforms: [CGAffineTransform]) -> Self {
        
        var transformableObject = self
        
        transforms.forEach { (transform) in
            transformableObject = transformableObject.applying(transform)
        }
        
        return transformableObject
    }
    
}
