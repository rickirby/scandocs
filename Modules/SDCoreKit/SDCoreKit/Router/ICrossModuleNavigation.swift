//
//  ICrossModuleNavigation.swift
//  SDCoreKit
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit

public protocol ICrossModuleNavigation: AnyObject {
    func navigateToCamera(documentGroup: Any?)
    func navigateToImagePicker(documentGroup: Any?)
    func navigateToPhotosGallery(documentGroup: Any, initialSelectedIndex: Int)
    func navigateToEditScan(image: UIImage, rectanglePoint: Any?, isRotateImage: Bool, documentGroup: Any?, currentDocument: Any?)
    func navigateToEditScan(image: UIImage, quadrilateral: Any?, isRotateImage: Bool, documentGroup: Any?)
}

public extension ICrossModuleNavigation {
    func navigateToCamera(documentGroup: Any? = nil) {
        navigateToCamera(documentGroup: documentGroup)
    }
    
    func navigateToImagePicker(documentGroup: Any? = nil) {
        navigateToImagePicker(documentGroup: documentGroup)
    }
    
    func navigateToEditScan(image: UIImage, rectanglePoint: Any?, isRotateImage: Bool = false, documentGroup: Any?, currentDocument: Any?) {
        navigateToEditScan(image: image, rectanglePoint: rectanglePoint, isRotateImage: isRotateImage, documentGroup: documentGroup, currentDocument: currentDocument)
    }
    
    func navigateToEditScan(image: UIImage, quadrilateral: Any?, isRotateImage: Bool = false, documentGroup: Any?) {
        navigateToEditScan(image: image, quadrilateral: quadrilateral, isRotateImage: isRotateImage, documentGroup: documentGroup)
    }
}
