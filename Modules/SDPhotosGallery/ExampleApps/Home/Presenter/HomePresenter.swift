//
//  HomePresenter.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import SDCloudKitModel

protocol IHomePresenter: AnyObject {
    func distributeTableData(data: [String])
    func navigateToPhotsGallery(documentGroup: DocumentGroup, initialSelectedIndex: Int)
}

final class HomePresenter: IHomePresenter {
    
    weak var view: IHomeViewController?
    
    func distributeTableData(data: [String]) {
        view?.distributeTableData(data: data)
    }
    
    func navigateToPhotsGallery(documentGroup: DocumentGroup, initialSelectedIndex: Int) {
        view?.navigateToPhotsGallery(documentGroup: documentGroup, initialSelectedIndex: initialSelectedIndex)
    }
}
