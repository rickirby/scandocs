//
//  HomeInteractor.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit

protocol IHomeInteractor: AnyObject {
    func tapStartCameraButton()
}

final class HomeInteractor: IHomeInteractor {
    
    private let presenter: IHomePresenter
    
    init(presenter: IHomePresenter) {
        self.presenter = presenter
    }
    
    func tapStartCameraButton() {
        presenter.navigateToCamera()
    }
}
