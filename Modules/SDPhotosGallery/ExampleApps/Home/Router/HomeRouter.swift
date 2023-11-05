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
    func navigateToPhotsGallery(documentGroup: DocumentGroup, initialSelectedIndex: Int)
}

final class HomeRouter: IHomeRouter {
    private let appRouter: IAppRouter
    
    init(appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func navigateToPhotsGallery(documentGroup: DocumentGroup, initialSelectedIndex: Int) {
        guard let crossModuleNavigation: ICrossModuleNavigation = UIApplication.shared.delegate as? ICrossModuleNavigation else {
            return
        }
        
        crossModuleNavigation.navigateToPhotosGallery(documentGroup: documentGroup, initialSelectedIndex: initialSelectedIndex)
    }
}
