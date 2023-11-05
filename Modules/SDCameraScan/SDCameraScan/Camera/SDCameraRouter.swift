//
//  SDCameraRouter.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 30/10/23.
//

import UIKit
import SDCoreKit
import SDScanKit

protocol ISDCameraRouter: AnyObject {
    func navigateBack()
    func navigateToImagePicker(documentGroup: Any?)
    func navigateToEditScan(image: UIImage, quadrilateral: Quadrilateral?, documentGroup: Any?)
}

final class SDCameraRouter: ISDCameraRouter {
    private let appRouter: IAppRouter
    
    init(appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func navigateBack() {
        appRouter.navigateBack()
    }
    
    func navigateToImagePicker(documentGroup: Any?) {
        guard let crossModuleNavigation: ICrossModuleNavigation = UIApplication.shared.delegate as? ICrossModuleNavigation else {
            return
        }
        
        crossModuleNavigation.navigateToImagePicker(documentGroup: documentGroup)
    }
    
    func navigateToEditScan(image: UIImage, quadrilateral: Quadrilateral?, documentGroup: Any?) {
        guard let crossModuleNavigation: ICrossModuleNavigation = UIApplication.shared.delegate as? ICrossModuleNavigation else {
            return
        }
        
        crossModuleNavigation.navigateToEditScan(image: image, quadrilateral: quadrilateral, isRotateImage: true, documentGroup: documentGroup)
    }
}
