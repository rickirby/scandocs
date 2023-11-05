//
//  SDEditScanModule.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 24/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel

public final class SDEditScanModule: IModule {
    
    private let appRouter: IAppRouter
    
    public init(_ appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    public func presentView(parameters: [String : Any]) {
        let view: UIViewController = createView(parameters: parameters)
        appRouter.presentView(view: view)
    }
    
    public func createView(parameters: [String : Any]) -> UIViewController {
        guard let image: UIImage = parameters["image"] as? UIImage else {
            return UIViewController()
        }
        let rectanglePoint: RectanglePoint? = parameters["rectanglePoint"] as? RectanglePoint
        let isRotateImage: Bool = parameters["isRotateImage"] as? Bool ?? false
        let documentGroup: DocumentGroup? = parameters["documentGroup"] as? DocumentGroup
        let currentDocument: Document? = parameters["currentDocument"] as? Document
        
        let presenter: SDEditScanPresenter = SDEditScanPresenter()
        let interactor: SDEditScanInteractor = SDEditScanInteractor(presenter: presenter, image: image, rectanglePoint: rectanglePoint, isRotateImage: isRotateImage, documentGroup: documentGroup, currentDocument: currentDocument)
        let router: SDEditScanRouter = SDEditScanRouter(appRouter: appRouter)
        let viewController: SDEditScanViewController = SDEditScanViewController(interactor: interactor, router: router)
        presenter.view = viewController
        
        return viewController
    }
}
