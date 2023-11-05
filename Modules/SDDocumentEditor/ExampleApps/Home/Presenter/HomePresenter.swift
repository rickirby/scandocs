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
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint?, isRotateImage: Bool, documentGroup: DocumentGroup?, currentDocument: Document?)
}

final class HomePresenter: IHomePresenter {
    
    weak var view: IHomeViewController?
    
    func distributeTableData(data: [String]) {
        view?.distributeTableData(data: data)
    }
    
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint?, isRotateImage: Bool, documentGroup: DocumentGroup?, currentDocument: Document?) {
        view?.navigateToEditScan(image: image, rectanglePoint: rectanglePoint, isRotateImage: isRotateImage, documentGroup: documentGroup, currentDocument: currentDocument)
    }
}
