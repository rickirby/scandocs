//
//  SDScanAlbumsModule.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel
import SDDatabaseWorker

final class SDScanAlbumsModule: IModule {
    
    private let appRouter: IAppRouter
    
    init(_ appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func presentView(parameters: [String : Any]) {
        let view: UIViewController = createView(parameters: parameters)
        appRouter.presentView(view: view)
    }
    
    func createView(parameters: [String : Any]) -> UIViewController {
        let presenter: SDScanAlbumsPresenter = SDScanAlbumsPresenter()
        let databaseWorker: DatabaseWorker = DatabaseWorker()
        let interactor: SDScanAlbumsInteractor = SDScanAlbumsInteractor(presenter: presenter, databaseWorker: databaseWorker)
        let router: SDScanAlbumsRouter = SDScanAlbumsRouter(appRouter: appRouter)
        let viewController: SDScanAlbumsViewController = SDScanAlbumsViewController(interactor: interactor, router: router)
        presenter.view = viewController
        
        return viewController
    }
}
