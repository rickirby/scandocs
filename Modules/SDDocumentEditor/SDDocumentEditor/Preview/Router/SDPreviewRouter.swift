//
//  SDPreviewRouter.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 27/10/23.
//

import UIKit
import SDCoreKit

protocol ISDPreviewRouter: AnyObject {
    func navigateBackToScanAlbums()
    func navigateBackToDocumentGroup()
}

final class SDPreviewRouter: ISDPreviewRouter {
    private let appRouter: IAppRouter
    
    init(appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func navigateBackToScanAlbums() {
        appRouter.navigateBackToRoot()
    }
    
    func navigateBackToDocumentGroup() {
        appRouter.navigateBackToScreen(identifier: .documentGroup)
    }
}
