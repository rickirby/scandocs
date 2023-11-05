//
//  SDImagePickerRouter.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 01/11/23.
//

import UIKit
import SDCoreKit
import SDScanKit

protocol ISDImagePickerRouter: AnyObject {
    func navigateToEditScan(image: UIImage, quadrilateral: Quadrilateral?, documentGroup: Any?)
}

final class SDImagePickerRouter: ISDImagePickerRouter {
    private let appRouter: IAppRouter
    
    init(appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func navigateToEditScan(image: UIImage, quadrilateral: Quadrilateral?, documentGroup: Any?) {
        guard let crossModuleNavigation: ICrossModuleNavigation = UIApplication.shared.delegate as? ICrossModuleNavigation else {
            return
        }
        
        crossModuleNavigation.navigateToEditScan(image: image, quadrilateral: quadrilateral, isRotateImage: false, documentGroup: documentGroup)
    }
}
