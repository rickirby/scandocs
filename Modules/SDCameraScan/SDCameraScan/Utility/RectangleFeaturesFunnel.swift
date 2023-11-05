//
//  RectangleFeaturesFunnel.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 29/10/23.
//

import UIKit
import AVFoundation
import SDScanKit

final class RectangleFeaturesFunnel {
    
    private final class RectangleMatch: NSObject {
        let rectangleFeature: Quadrilateral
        var matchingScore = 0
        
        init(rectangleFeature: Quadrilateral) {
            self.rectangleFeature = rectangleFeature
        }
        
        override var description: String {
            return "Matching score: \(matchingScore) - Rectangle: \(rectangleFeature)"
        }
        
        func matches(_ rectangle: Quadrilateral, withThreshold threshold: CGFloat) -> Bool {
            return rectangleFeature.isWithin(threshold, ofRectangleFeature: rectangle)
        }
    }
    
    private var rectangles = [RectangleMatch]()
    let maxNumberOfRectangles = 8
    let minNumberOfRectangles = 3
    let matchingThreshold: CGFloat = 40.0
    let minNumberOfMatches = 3
    let autoScanThreshold = 35
    var currentAutoScanPassCount = 0
    var autoScanMatchingThreshold: CGFloat = 6.0
    
    func add(_ rectangleFeature: Quadrilateral, currentlyDisplayedRectangle currentRectangle: Quadrilateral?, completion: (AddResult, Quadrilateral) -> Void) {
        let rectangleMatch = RectangleMatch(rectangleFeature: rectangleFeature)
        rectangles.append(rectangleMatch)
        
        guard rectangles.count >= minNumberOfRectangles else {
            return
        }
        
        if rectangles.count > maxNumberOfRectangles {
            rectangles.removeFirst()
        }
        
        updateRectangleMatches()
        
        guard let bestRectangle = bestRectangle(withCurrentlyDisplayedRectangle: currentRectangle) else {
            return
        }
        
        if let previousRectangle = currentRectangle,
            bestRectangle.rectangleFeature.isWithin(autoScanMatchingThreshold, ofRectangleFeature: previousRectangle) {
            currentAutoScanPassCount += 1
            if currentAutoScanPassCount > autoScanThreshold {
                currentAutoScanPassCount = 0
                completion(AddResult.showAndAutoScan, bestRectangle.rectangleFeature)
            }
        } else {
            completion(AddResult.showOnly, bestRectangle.rectangleFeature)
        }
    }
    
    private func bestRectangle(withCurrentlyDisplayedRectangle currentRectangle: Quadrilateral?) -> RectangleMatch? {
        var bestMatch: RectangleMatch?
        guard !rectangles.isEmpty else { return nil }
        rectangles.reversed().forEach { (rectangle) in
            guard let best = bestMatch else {
                bestMatch = rectangle
                return
            }
            
            if rectangle.matchingScore > best.matchingScore {
                bestMatch = rectangle
                return
            } else if rectangle.matchingScore == best.matchingScore {
                guard let currentRectangle = currentRectangle else {
                    return
                }
                
                bestMatch = breakTie(between: best, rect2: rectangle, currentRectangle: currentRectangle)
            }
        }
        
        return bestMatch
    }
    
    private func breakTie(between rect1: RectangleMatch, rect2: RectangleMatch, currentRectangle: Quadrilateral) -> RectangleMatch {
        if rect1.rectangleFeature.isWithin(matchingThreshold, ofRectangleFeature: currentRectangle) {
            return rect1
        } else if rect2.rectangleFeature.isWithin(matchingThreshold, ofRectangleFeature: currentRectangle) {
            return rect2
        }
        
        return rect1
    }
    
    private func updateRectangleMatches() {
        resetMatchingScores()
        guard !rectangles.isEmpty else { return }
        for (i, currentRect) in rectangles.enumerated() {
            for (j, rect) in rectangles.enumerated() {
                if j > i && currentRect.matches(rect.rectangleFeature, withThreshold: matchingThreshold) {
                    currentRect.matchingScore += 1
                    rect.matchingScore += 1
                }
            }
        }
    }
    
    private func resetMatchingScores() {
        guard !rectangles.isEmpty else { return }
        for rectangle in rectangles {
            rectangle.matchingScore = 1
        }
    }
}
