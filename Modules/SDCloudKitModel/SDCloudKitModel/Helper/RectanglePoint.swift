//
//  RectanglePoint.swift
//  SDCloudKitModel
//
//  Created by Ricki Bin Yamin on 10/10/23.
//

import UIKit
import CoreData

/// A bridge between Quadrilateral and QuadPoint
public struct RectanglePoint {
    public let topLeft: CGPoint
    public let topRight: CGPoint
    public let bottomRight: CGPoint
    public let bottomLeft: CGPoint
    
    public init(topLeft: CGPoint, topRight: CGPoint, bottomRight: CGPoint, bottomLeft: CGPoint) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomRight = bottomRight
        self.bottomLeft = bottomLeft
    }
    
    public init(quadPoint: QuadPoint) {
        self.topLeft = CGPoint(x: quadPoint.topLeftX, y: quadPoint.topLeftY)
        self.topRight = CGPoint(x: quadPoint.topRightX, y: quadPoint.topRightY)
        self.bottomLeft = CGPoint(x: quadPoint.bottomLeftX, y: quadPoint.bottomLeftY)
        self.bottomRight = CGPoint(x: quadPoint.bottomRightX, y: quadPoint.bottomRightY)
    }
    
    public func createQuadPoint(managedContext: NSManagedObjectContext) -> QuadPoint {
        let quadPoint: QuadPoint = QuadPoint(context: managedContext)
        quadPoint.topLeftX = Double(topLeft.x)
        quadPoint.topLeftY = Double(topLeft.y)
        quadPoint.topRightX = Double(topRight.x)
        quadPoint.topRightY = Double(topRight.y)
        quadPoint.bottomLeftX = Double(bottomLeft.x)
        quadPoint.bottomLeftY = Double(bottomLeft.y)
        quadPoint.bottomRightX = Double(bottomRight.x)
        quadPoint.bottomRightY = Double(bottomRight.y)
        
        return quadPoint
    }
}
