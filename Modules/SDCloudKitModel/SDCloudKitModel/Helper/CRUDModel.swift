//
//  RectanglePoint.swift
//  SDCloudKitModel
//
//  Created by Ricki Bin Yamin on 10/10/23.
//

import UIKit

public struct UpdateCurrentDocumentModel {
    public let documentGroup: DocumentGroup
    public let currentDocument: Document
    public let newRectanglePoint: RectanglePoint?
    public let newRotationAngle: Double?
    public let newThumbnailImage: UIImage
    
    public init(documentGroup: DocumentGroup, currentDocument: Document, newRectanglePoint: RectanglePoint?, newRotationAngle: Double?, newThumbnailImage: UIImage) {
        self.documentGroup = documentGroup
        self.currentDocument = currentDocument
        self.newRectanglePoint = newRectanglePoint
        self.newRotationAngle = newRotationAngle
        self.newThumbnailImage = newThumbnailImage
    }
}

public struct AddNewDocumentToDocumentGroupModel {
    public let documentGroup: DocumentGroup
    public let originalImage: UIImage
    public let thumbnailImage: UIImage
    public let rectanglePoint: RectanglePoint
    public let rotationAngle: Double
    
    public init(documentGroup: DocumentGroup, originalImage: UIImage, thumbnailImage: UIImage, rectanglePoint: RectanglePoint, rotationAngle: Double) {
        self.documentGroup = documentGroup
        self.originalImage = originalImage
        self.thumbnailImage = thumbnailImage
        self.rectanglePoint = rectanglePoint
        self.rotationAngle = rotationAngle
    }
}

public struct AddNewDocumentGroupModel {
    public let name: String
    public let originalImage: UIImage
    public let thumbnailImage: UIImage
    public let rectanglePoint: RectanglePoint
    public let rotationAngle: Double
    
    public init(name: String, originalImage: UIImage, thumbnailImage: UIImage, rectanglePoint: RectanglePoint, rotationAngle: Double) {
        self.name = name
        self.originalImage = originalImage
        self.thumbnailImage = thumbnailImage
        self.rectanglePoint = rectanglePoint
        self.rotationAngle = rotationAngle
    }
}

