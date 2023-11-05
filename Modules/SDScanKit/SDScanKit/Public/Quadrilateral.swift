//
//  Quadrilateral.swift
//  SDScanKit
//
//  Created by Ricki Bin Yamin on 24/10/23.
//

import UIKit
import AVFoundation
import Vision

public struct Quadrilateral: Transformable {
    
    public var topLeft: CGPoint
    public var topRight: CGPoint
    public var bottomRight: CGPoint
    public var bottomLeft: CGPoint
    
    public var description: String {
        return "topLeft: \(topLeft), topRight: \(topRight), bottomRight: \(bottomRight), bottomLeft: \(bottomLeft)"
    }
    
    var path: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.close()
        
        return path
    }
    
    var perimeter: Double {
        let perimeter = topLeft.distanceTo(point: topRight) + topRight.distanceTo(point: bottomRight) + bottomRight.distanceTo(point: bottomLeft) + bottomLeft.distanceTo(point: topLeft)
        return Double(perimeter)
    }
    
    public init(rectangleFeature: CIRectangleFeature) {
        self.topLeft = rectangleFeature.topLeft
        self.topRight = rectangleFeature.topRight
        self.bottomLeft = rectangleFeature.bottomLeft
        self.bottomRight = rectangleFeature.bottomRight
    }
    
    public init(rectangleObservation: VNRectangleObservation) {
        self.topLeft = rectangleObservation.topLeft
        self.topRight = rectangleObservation.topRight
        self.bottomLeft = rectangleObservation.bottomLeft
        self.bottomRight = rectangleObservation.bottomRight
    }
    
    public init(topLeft: CGPoint, topRight: CGPoint, bottomRight: CGPoint, bottomLeft: CGPoint) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomRight = bottomRight
        self.bottomLeft = bottomLeft
    }
    
    public func applying(_ transform: CGAffineTransform) -> Quadrilateral {
        let quadrilateral = Quadrilateral(topLeft: topLeft.applying(transform), topRight: topRight.applying(transform), bottomRight: bottomRight.applying(transform), bottomLeft: bottomLeft.applying(transform))
        
        return quadrilateral
    }
    
    public func isWithin(_ distance: CGFloat, ofRectangleFeature rectangleFeature: Quadrilateral) -> Bool {
        let topLeftRect = topLeft.surroundingSquare(withSize: distance)
        if !topLeftRect.contains(rectangleFeature.topLeft) {
            return false
        }
        
        let topRightRect = topRight.surroundingSquare(withSize: distance)
        if !topRightRect.contains(rectangleFeature.topRight) {
            return false
        }
        
        let bottomRightRect = bottomRight.surroundingSquare(withSize: distance)
        if !bottomRightRect.contains(rectangleFeature.bottomRight) {
            return false
        }
        
        let bottomLeftRect = bottomLeft.surroundingSquare(withSize: distance)
        if !bottomLeftRect.contains(rectangleFeature.bottomLeft) {
            return false
        }
        
        return true
    }
    
    public mutating func reorganize() {
        let points = [topLeft, topRight, bottomRight, bottomLeft]
        let ySortedPoints = sortPointsByYValue(points)
        
        guard ySortedPoints.count == 4 else {
            return
        }
        
        let topMostPoints = Array(ySortedPoints[0..<2])
        let bottomMostPoints = Array(ySortedPoints[2..<4])
        let xSortedTopMostPoints = sortPointsByXValue(topMostPoints)
        let xSortedBottomMostPoints = sortPointsByXValue(bottomMostPoints)
        
        guard xSortedTopMostPoints.count > 1,
            xSortedBottomMostPoints.count > 1 else {
                return
        }
        
        topLeft = xSortedTopMostPoints[0]
        topRight = xSortedTopMostPoints[1]
        bottomRight = xSortedBottomMostPoints[1]
        bottomLeft = xSortedBottomMostPoints[0]
    }
    
    public func scale(_ fromSize: CGSize, _ toSize: CGSize, withRotationAngle rotationAngle: CGFloat = 0.0) -> Quadrilateral {
        var invertedfromSize = fromSize
        let rotated = rotationAngle != 0.0
        
        if rotated && rotationAngle != CGFloat.pi {
            invertedfromSize = CGSize(width: fromSize.height, height: fromSize.width)
        }
        
        var transformedQuad = self
        let invertedFromSizeWidth = invertedfromSize.width == 0 ? .leastNormalMagnitude : invertedfromSize.width
        
        let scale = toSize.width / invertedFromSizeWidth
        let scaledTransform = CGAffineTransform(scaleX: scale, y: scale)
        transformedQuad = transformedQuad.applying(scaledTransform)
        
        if rotated {
            let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
            
            let fromImageBounds = CGRect(origin: .zero, size: fromSize).applying(scaledTransform).applying(rotationTransform)
            
            let toImageBounds = CGRect(origin: .zero, size: toSize)
            let translationTransform = CGAffineTransform.translateTransform(fromCenterOfRect: fromImageBounds, toCenterOfRect: toImageBounds)
            
            transformedQuad = transformedQuad.applyTransforms([rotationTransform, translationTransform])
        }
        
        return transformedQuad
    }
    
    private func sortPointsByYValue(_ points: [CGPoint]) -> [CGPoint] {
        return points.sorted { (point1, point2) -> Bool in
            point1.y < point2.y
        }
    }
    
    private func sortPointsByXValue(_ points: [CGPoint]) -> [CGPoint] {
        return points.sorted { (point1, point2) -> Bool in
            point1.x < point2.x
        }
    }
    
    public func toCartesian(withHeight height: CGFloat) -> Quadrilateral {
        let topLeft = self.topLeft.cartesian(withHeight: height)
        let topRight = self.topRight.cartesian(withHeight: height)
        let bottomRight = self.bottomRight.cartesian(withHeight: height)
        let bottomLeft = self.bottomLeft.cartesian(withHeight: height)
        
        return Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
    }
    
    public static func defaultQuad(forImage image: UIImage) -> Quadrilateral {
        let topLeft = CGPoint(x: image.size.width / 3.0, y: image.size.height / 3.0)
        let topRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: image.size.height / 3.0)
        let bottomRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
        let bottomLeft = CGPoint(x: image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
        
        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        return quad
    }
    
    public static func allFrameQuad(forImage image: UIImage) -> Quadrilateral {
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: image.size.width, y: 0)
        let bottomRight = CGPoint(x: image.size.width, y: image.size.height)
        let bottomLeft = CGPoint(x: 0, y: image.size.height)
        
        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        return quad
    }
}

extension Quadrilateral: Equatable {
    public static func == (lhs: Quadrilateral, rhs: Quadrilateral) -> Bool {
        return lhs.topLeft == rhs.topLeft && lhs.topRight == rhs.topRight && lhs.bottomRight == rhs.bottomRight && lhs.bottomLeft == rhs.bottomLeft
    }
}

public extension Array where Element == Quadrilateral {
    func biggest() -> Quadrilateral? {
        let biggestRectangle = self.max(by: { (rect1, rect2) -> Bool in
            return rect1.perimeter < rect2.perimeter
        })
        
        return biggestRectangle
    }
}
