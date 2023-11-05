//
//  BaseAppRouter.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit

public enum PresentType {
    case push
    case present
}

public protocol IAppRouter {
    func presentModule(module: IModule.Type, parameters: [String: Any])
    func presentView(view: UIViewController, presentType: PresentType, animated: Bool, completion: (() -> Void)?)
    func navigateBack(animated: Bool)
    func navigateBackToRoot(animated: Bool)
    func navigateBackToScreen(identifier: ScreenIdentifierName, animated: Bool)
}

public extension IAppRouter {
    func presentModule(module: IModule.Type, parameters: [String: Any] = [:]) {
        presentModule(module: module, parameters: parameters)
    }
    
    func presentView(view: UIViewController, presentType: PresentType = .push, animated: Bool = true, completion: (() -> Void)? = nil) {
        presentView(view: view, presentType: presentType, animated: animated, completion: completion)
    }
    
    func navigateBack(animated: Bool = true) {
        navigateBack(animated: animated)
    }
    
    func navigateBackToRoot(animated: Bool = true) {
        navigateBackToRoot(animated: animated)
    }
    
    func navigateBackToScreen(identifier: ScreenIdentifierName, animated: Bool = true) {
        navigateBackToScreen(identifier: identifier, animated: animated)
    }
}

open class BaseAppRouter: IAppRouter {
    open var window: UIWindow?
    
    public init() {}
    
    open func presentModule(module: IModule.Type, parameters: [String: Any]) {
        let module = module.init(self)
        module.presentView(parameters: parameters)
    }
    
    open func presentView(view: UIViewController, presentType: PresentType, animated: Bool, completion: (() -> Void)?) {
        guard window?.rootViewController != nil else {
            let navigationController: UINavigationController = UINavigationController(rootViewController: view)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            return
        }
        
        switch presentType {
        case .push:
            UIApplication.activeNavigationController()?.pushViewController(view, animated: true)
            completion?()
        case .present:
            UIApplication.topViewController()?.present(view, animated: animated, completion: completion)
        }
    }
    
    open func navigateBack(animated: Bool) {
        UIApplication.activeNavigationController()?.popViewController(animated: animated)
    }
    
    open func navigateBackToRoot(animated: Bool) {
        UIApplication.activeNavigationController()?.popToRootViewController(animated: animated)
    }
    
    open func navigateBackToScreen(identifier: ScreenIdentifierName, animated: Bool) {
        guard let viewControllerStack: [UIViewController] = UIApplication.activeNavigationController()?.viewControllers else {
            return
        }
        
        for viewController in viewControllerStack {
            if let viewControllerWithIdentifier: IScreenIdentifier = viewController as? IScreenIdentifier, viewControllerWithIdentifier.identifierName == identifier {
                UIApplication.activeNavigationController()?.popToViewController(viewController, animated: animated)
                
                break
            }
        }
    }
}

