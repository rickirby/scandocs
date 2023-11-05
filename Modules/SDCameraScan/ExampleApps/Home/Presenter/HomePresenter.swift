//
//  HomePresenter.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit

protocol IHomePresenter: AnyObject {
    func navigateToCamera()
}

final class HomePresenter: IHomePresenter {
    
    weak var view: IHomeViewController?
    
    func navigateToCamera() {
        view?.navigateToCamera()
    }
}
