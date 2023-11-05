//
//  SDEditScanRouter.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 24/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel
import SDScanKit

protocol ISDEditScanRouter: AnyObject {
    func navigateToPreview(image: UIImage, quad: Quadrilateral, documentGroup: DocumentGroup?, currentDocument: Document?)
}

final class SDEditScanRouter: ISDEditScanRouter {
    private let appRouter: IAppRouter
    
    init(appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func navigateToPreview(image: UIImage, quad: Quadrilateral, documentGroup: DocumentGroup?, currentDocument: Document?) {
        var parameters: [String: Any] = [:]
        
        parameters["image"] = image
        
        parameters["quad"] = quad
        
        if let documentGroup {
            parameters["documentGroup"] = documentGroup
        }
        
        if let currentDocument {
            parameters["currentDocument"] = currentDocument
        }
        
        appRouter.presentModule(module: SDPreviewModule.self, parameters: parameters)
    }
}
