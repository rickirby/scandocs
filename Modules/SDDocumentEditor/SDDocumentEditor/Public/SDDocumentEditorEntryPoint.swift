//
//  SDDocumentEditorEntryPoint.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 22/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel
import SDScanKit

public extension BaseAppRouter {
    func navigateToEditScan(image: UIImage, rectanglePoint: Any?, isRotateImage: Bool?, documentGroup: Any?, currentDocument: Any?) {
        var parameters: [String: Any] = [:]
        
        parameters["image"] = image
        
        if let rectanglePoint {
            parameters["rectanglePoint"] = rectanglePoint
        }
        
        if let isRotateImage {
            parameters["isRotateImage"] = isRotateImage
        }
        
        if let documentGroup {
            parameters["documentGroup"] = documentGroup
        }
        
        if let currentDocument {
            parameters["currentDocument"] = currentDocument
        }
        
        presentModule(module: SDEditScanModule.self, parameters: parameters)
    }
    
    func navigateToEditScan(image: UIImage, quadrilateral: Any?, isRotateImage: Bool?, documentGroup: Any?) {
        var parameters: [String: Any] = [:]
        
        parameters["image"] = image
        
        if let quadrilateral: Quadrilateral = quadrilateral as? Quadrilateral {
            let rectanglePoint: RectanglePoint = RectanglePoint(quadrilateral: quadrilateral)
            parameters["rectanglePoint"] = rectanglePoint
        }
        
        if let isRotateImage {
            parameters["isRotateImage"] = isRotateImage
        }
        
        if let documentGroup {
            parameters["documentGroup"] = documentGroup
        }
        
        presentModule(module: SDEditScanModule.self, parameters: parameters)
    }
}
