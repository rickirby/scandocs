//
//  AppDelegate+CrossModuleNavigation.swift
//  Scandocs
//
//  Created by Ricki Bin Yamin on 22/10/23.
//

import UIKit
import SDCoreKit
import SDPhotosGallery
import SDDocumentEditor
import SDCameraScan

extension AppDelegate: ICrossModuleNavigation {
    func navigateToCamera(documentGroup: Any?) {
        AppRouter.shared.navigateToCamera(documentGroup: documentGroup)
    }
    
    func navigateToImagePicker(documentGroup: Any?) {
        AppRouter.shared.openImagePicker(documentGroup: documentGroup)
    }
    
    func navigateToPhotosGallery(documentGroup: Any, initialSelectedIndex: Int) {
        AppRouter.shared.navigateToPhotosGallery(documentGroup: documentGroup, initialSelectedIndex: initialSelectedIndex)
    }
    
    func navigateToEditScan(image: UIImage, rectanglePoint: Any?, isRotateImage: Bool, documentGroup: Any?, currentDocument: Any?) {
        AppRouter.shared.navigateToEditScan(image: image, rectanglePoint: rectanglePoint, isRotateImage: isRotateImage, documentGroup: documentGroup, currentDocument: currentDocument)
    }
    
    func navigateToEditScan(image: UIImage, quadrilateral: Any?, isRotateImage: Bool, documentGroup: Any?) {
        AppRouter.shared.navigateToEditScan(image: image, quadrilateral: quadrilateral, isRotateImage: isRotateImage, documentGroup: documentGroup)
    }
}
