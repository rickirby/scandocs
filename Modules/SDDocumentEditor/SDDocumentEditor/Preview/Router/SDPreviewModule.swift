//
//  SDPreviewModule.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 27/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel
import SDScanKit

public final class SDPreviewModule: IModule {
    
    private let appRouter: IAppRouter
    
    public init(_ appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    public func presentView(parameters: [String : Any]) {
        let view: UIViewController = createView(parameters: parameters)
        appRouter.presentView(view: view)
    }
    
    public func createView(parameters: [String : Any]) -> UIViewController {
        guard
            let image: UIImage = parameters["image"] as? UIImage,
            let quad: Quadrilateral = parameters["quad"] as? Quadrilateral
        else {
            return UIViewController()
        }
        
        let documentGroup: DocumentGroup? = parameters["documentGroup"] as? DocumentGroup
        let currentDocument: Document? = parameters["currentDocument"] as? Document
        
        let presenter: SDPreviewPresenter = SDPreviewPresenter()
        let interactor: SDPreviewInteractor = SDPreviewInteractor(presenter: presenter, image: image, quad: quad, documentGroup: documentGroup, currentDocument: currentDocument)
        let router: SDPreviewRouter = SDPreviewRouter(appRouter: appRouter)
        let viewController: SDPreviewViewController = SDPreviewViewController(interactor: interactor, router: router)
        presenter.view = viewController
        
        return viewController
    }
}
