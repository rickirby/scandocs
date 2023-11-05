//
//  HomeRouter.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel

protocol IHomeRouter: AnyObject {
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint?, isRotateImage: Bool, documentGroup: DocumentGroup?, currentDocument: Document?)
}

final class HomeRouter: IHomeRouter {
    private let appRouter: IAppRouter
    
    init(appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint?, isRotateImage: Bool, documentGroup: DocumentGroup?, currentDocument: Document?) {
        guard let crossModuleNavigation: ICrossModuleNavigation = UIApplication.shared.delegate as? ICrossModuleNavigation else {
            return
        }
        
        crossModuleNavigation.navigateToEditScan(image: image, rectanglePoint: rectanglePoint, isRotateImage: isRotateImage, documentGroup: documentGroup, currentDocument: currentDocument)
    }
}
