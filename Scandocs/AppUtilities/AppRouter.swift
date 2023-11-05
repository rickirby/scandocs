//
//  AppRouter.swift
//  Scandocs
//
//  Created by Ricki Bin Yamin on 22/10/23.
//

import UIKit
import SDCoreKit

final class AppRouter: BaseAppRouter {
    
    static var shared: AppRouter = AppRouter().create()
    static var scene: UIScene?
    
    private func create() -> AppRouter {
        var window: UIWindow?
        let router = AppRouter()

        if let _window = UIApplication.shared.activeWindow {
            window = _window
        } else {
            guard
                let windowScene = (AppRouter.scene as? UIWindowScene),
                let sceneDelegate: SceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            else {
                return router
            }
            window = UIWindow(windowScene: windowScene)
            window?.makeKeyAndVisible()
            
            sceneDelegate.window = window
        }

        router.window = window
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window = window

        return router
    }
}
