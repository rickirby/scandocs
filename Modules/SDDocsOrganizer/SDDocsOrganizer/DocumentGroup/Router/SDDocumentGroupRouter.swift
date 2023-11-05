//
//  SDDocumentGroupRouter.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 13/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel

protocol ISDDocumentGroupRouter: AnyObject {
    func navigateToCamera(documentGroup: DocumentGroup)
    func navigateToImagePicker(documentGroup: DocumentGroup)
    func navigateToPhotosGallery(documentGroup: DocumentGroup, initialSelectedIndex: Int)
}

final class SDDocumentGroupRouter: ISDDocumentGroupRouter {
    private let appRouter: IAppRouter
    
    init(appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func navigateToCamera(documentGroup: DocumentGroup) {
        guard let crossModuleNavigation: ICrossModuleNavigation = UIApplication.shared.delegate as? ICrossModuleNavigation else {
            return
        }
        
        crossModuleNavigation.navigateToCamera(documentGroup: documentGroup)
    }
    
    func navigateToImagePicker(documentGroup: DocumentGroup) {
        guard let crossModuleNavigation: ICrossModuleNavigation = UIApplication.shared.delegate as? ICrossModuleNavigation else {
            return
        }
        
        crossModuleNavigation.navigateToImagePicker(documentGroup: documentGroup)
    }
    
    func navigateToPhotosGallery(documentGroup: DocumentGroup, initialSelectedIndex: Int) {
        guard let crossModuleNavigation: ICrossModuleNavigation = UIApplication.shared.delegate as? ICrossModuleNavigation else {
            return
        }
        
        crossModuleNavigation.navigateToPhotosGallery(documentGroup: documentGroup, initialSelectedIndex: initialSelectedIndex)
    }
}
