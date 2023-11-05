//
//  SDScanAlbumsRouter.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel

protocol ISDScanAlbumsRouter: AnyObject {
    func navigateToDocumentPage(documentGroup: DocumentGroup)
    func navigateToCamera()
}

final class SDScanAlbumsRouter: ISDScanAlbumsRouter {
    private let appRouter: IAppRouter
    
    init(appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func navigateToDocumentPage(documentGroup: DocumentGroup) {
        let parameters: [String: Any] = [
            "documentGroup": documentGroup
        ]
        
        appRouter.presentModule(module: SDDocumentGroupModule.self, parameters: parameters)
    }
    
    func navigateToCamera() {
        guard let crossModuleNavigation: ICrossModuleNavigation = UIApplication.shared.delegate as? ICrossModuleNavigation else {
            return
        }
        
        crossModuleNavigation.navigateToCamera()
    }
}
