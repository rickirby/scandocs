//
//  SDCameraModule.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 29/10/23.
//

import UIKit
import SDCoreKit

final class SDCameraModule: IModule {
    
    private let appRouter: IAppRouter
    
    init(_ appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func presentView(parameters: [String : Any]) {
        let view: UIViewController = createView(parameters: parameters)
        appRouter.presentView(view: view)
    }
    
    func createView(parameters: [String : Any]) -> UIViewController {
        let documentGroup: Any? = parameters["documentGroup"]
        
        let router: SDCameraRouter = SDCameraRouter(appRouter: appRouter)
        let viewController: SDCameraViewController = SDCameraViewController(router: router, documentGroup: documentGroup)
        
        return viewController
    }
}
