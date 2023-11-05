//
//  HomeModule.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import SDCoreKit

public final class HomeModule: IModule {
    
    private let appRouter: IAppRouter
    
    public init(_ appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    public func presentView(parameters: [String : Any]) {
        let view: UIViewController = createView(parameters: parameters)
        appRouter.presentView(view: view)
    }
    
    public func createView(parameters: [String : Any]) -> UIViewController {
        let presenter: HomePresenter = HomePresenter()
        let interactor: HomeInteractor = HomeInteractor(presenter: presenter)
        let router: HomeRouter = HomeRouter(appRouter: appRouter)
        let viewController: HomeViewController = HomeViewController(interactor: interactor, router: router)
        presenter.view = viewController
        
        return viewController
    }
}
