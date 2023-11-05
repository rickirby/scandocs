//
//  IModule.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit

public protocol IModule {
    init(_ appRouter: IAppRouter)
    func presentView(parameters: [String: Any])
    func createView(parameters: [String: Any]) -> UIViewController
}
