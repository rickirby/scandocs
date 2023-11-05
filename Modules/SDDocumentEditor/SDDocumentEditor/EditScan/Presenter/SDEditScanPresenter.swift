//
//  SDEditScanPresenter.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 24/10/23.
//

import UIKit
import SDScanKit
import SDCloudKitModel

protocol ISDEditScanPresenter: AnyObject {
    func displayImage(image: UIImage)
    func displayQuadrilateral(quadrilateral: Quadrilateral)
    func showSuccessSavePhotoAlert()
    func showErrorSavePhotoAlert()
    func navigateToPreview(image: UIImage, quad: Quadrilateral, documentGroup: DocumentGroup?, currentDocument: Document?)
}

final class SDEditScanPresenter: ISDEditScanPresenter {
    
    weak var view: ISDEditScanViewController?
    
    func displayImage(image: UIImage) {
        view?.displayImage(image: image)
    }
    
    func displayQuadrilateral(quadrilateral: Quadrilateral) {
        view?.displayQuadrilateral(quadrilateral: quadrilateral)
    }
    
    func showSuccessSavePhotoAlert() {
        view?.showSuccessSavePhotoAlert()
    }
    
    func showErrorSavePhotoAlert() {
        view?.showErrorSavePhotoAlert()
    }
    
    func navigateToPreview(image: UIImage, quad: Quadrilateral, documentGroup: DocumentGroup?, currentDocument: Document?) {
        view?.navigateToPreview(image: image, quad: quad, documentGroup: documentGroup, currentDocument: currentDocument)
    }
}
