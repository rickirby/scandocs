//
//  UIApplication+activeWindow.swift
//  SDCoreKit
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit

public extension UIApplication {
    
    var activeWindow: UIWindow? {
        return UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
    }
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.activeWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = viewController as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        
        if let tabBarController = viewController as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return topViewController(selectedViewController)
            }
        }
        
        if let presentedViewController = viewController?.presentedViewController {
            return topViewController(presentedViewController)
        }
        
        return viewController
    }
    
    class func activeNavigationController() -> UINavigationController? {
        return UIApplication.topViewController()?.navigationController
    }
}
