//
//  SDPhotosGalleryModule.swift
//  SDPhotosGallery
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel

final class SDPhotosGalleryModule: IModule {
    
    private let appRouter: IAppRouter
    
    init(_ appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func presentView(parameters: [String : Any]) {
        let view: UIViewController = createView(parameters: parameters)
        appRouter.presentView(view: view)
    }
    
    func createView(parameters: [String : Any]) -> UIViewController {
        guard
            let documentGroup: DocumentGroup = parameters["documentGroup"] as? DocumentGroup,
            let initialSelectedIndex: Int = parameters["initialSelectedIndex"] as? Int
        else {
            return UIViewController()
        }
        
        let presenter: SDPhotosGalleryPresenter = SDPhotosGalleryPresenter()
        let interactor: SDPhotosGalleryInteractor = SDPhotosGalleryInteractor(presenter: presenter, documentGroup: documentGroup, initialSelectedIndex: initialSelectedIndex)
        let router: SDPhotosGalleryRouter = SDPhotosGalleryRouter(appRouter: appRouter)
        let viewController: SDPhotosGalleryViewController = SDPhotosGalleryViewController(interactor: interactor, router: router)
        presenter.view = viewController
        
        return viewController
    }
}
