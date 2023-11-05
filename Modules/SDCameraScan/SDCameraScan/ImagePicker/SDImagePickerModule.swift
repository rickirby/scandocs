//
//  SDImagePickerModule.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 01/11/23.
//

import UIKit
import SDCoreKit

final class SDImagePickerModule: IModule {
    
    private let appRouter: IAppRouter
    
    init(_ appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func presentView(parameters: [String : Any]) {
        let view: UIViewController = createView(parameters: parameters)
        appRouter.presentView(view: view, presentType: .present)
    }
    
    func createView(parameters: [String : Any]) -> UIViewController {
        let documentGroup: Any? = parameters["documentGroup"]
        
        let router: SDImagePickerRouter = SDImagePickerRouter(appRouter: appRouter)
        let viewController: SDImagePickerViewController = SDImagePickerViewController()
        viewController.router = router
        viewController.documentGroup = documentGroup
        
        return viewController
    }
}
