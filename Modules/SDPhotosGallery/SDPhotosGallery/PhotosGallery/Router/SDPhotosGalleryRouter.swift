//
//  SDPhotosGalleryRouter.swift
//  SDPhotosGallery
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel

protocol ISDPhotosGalleryRouter: AnyObject {
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint, documentGroup: DocumentGroup, currentDocument: Document)
    func navigateBackToDocumentGroup()
    func navigateBackToScanAlbums()
}

final class SDPhotosGalleryRouter: ISDPhotosGalleryRouter {
    private let appRouter: IAppRouter
    
    init(appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint, documentGroup: DocumentGroup, currentDocument: Document) {
        guard let crossModuleNavigation: ICrossModuleNavigation = UIApplication.shared.delegate as? ICrossModuleNavigation else {
            return
        }
        
        crossModuleNavigation.navigateToEditScan(image: image, rectanglePoint: rectanglePoint, documentGroup: documentGroup, currentDocument: currentDocument)
    }
    
    func navigateBackToDocumentGroup() {
        appRouter.navigateBackToScreen(identifier: .documentGroup)
    }
    
    func navigateBackToScanAlbums() {
        appRouter.navigateBackToRoot()
    }
}
