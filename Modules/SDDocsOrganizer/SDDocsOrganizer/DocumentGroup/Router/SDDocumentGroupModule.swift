//
//  SDDocumentGroupModule.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 13/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel
import SDDatabaseWorker

final class SDDocumentGroupModule: IModule {
    
    private let appRouter: IAppRouter
    
    init(_ appRouter: IAppRouter) {
        self.appRouter = appRouter
    }
    
    func presentView(parameters: [String : Any]) {
        let view: UIViewController = createView(parameters: parameters)
        appRouter.presentView(view: view)
    }
    
    func createView(parameters: [String : Any]) -> UIViewController {
        guard let documentGroup: DocumentGroup = parameters["documentGroup"] as? DocumentGroup else {
            return UIViewController()
        }
        
        let presenter: SDDocumentGroupPresenter = SDDocumentGroupPresenter()
        let databaseWorker: DatabaseWorker = DatabaseWorker()
        let interactor: SDDocumentGroupInteractor = SDDocumentGroupInteractor(presenter: presenter, databaseWorker: databaseWorker, documentGroup: documentGroup)
        let router: SDDocumentGroupRouter = SDDocumentGroupRouter(appRouter: appRouter)
        let viewController: SDDocumentGroupViewController = SDDocumentGroupViewController(interactor: interactor, router: router)
        presenter.view = viewController
        
        return viewController
    }
}
