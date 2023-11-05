//
//  SDPreviewPresenter.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 27/10/23.
//

import UIKit
import SDCoreKit

protocol ISDPreviewPresenter: AnyObject {
    func startLoading()
    func stopLoading()
    func showProcessedImage(processedImage: UIImage)
    func showErrorSavePhotoAlert()
    func showSuccessSavePhotoAlert()
    func showInsertDocumentGroupNameAlert()
    func navigateBackToScanAlbums()
    func navigateBackToDocumentGroup()
}

final class SDPreviewPresenter: ISDPreviewPresenter {
    
    weak var view: ISDPreviewViewController?
    
    func startLoading() {
        view?.startLoading()
    }
    
    func stopLoading() {
        view?.stopLoading()
    }
    
    func showProcessedImage(processedImage: UIImage) {
        view?.showProcessedImage(processedImage: processedImage)
    }
    
    func showErrorSavePhotoAlert() {
        view?.showErrorSavePhotoAlert()
    }
    
    func showSuccessSavePhotoAlert() {
        view?.showSuccessSavePhotoAlert()
    }
    
    func showInsertDocumentGroupNameAlert() {
        view?.showInsertDocumentGroupNameAlert()
    }
    
    func navigateBackToScanAlbums() {
        view?.navigateBackToScanAlbums()
    }
    
    func navigateBackToDocumentGroup() {
        view?.navigateBackToDocumentGroup()
    }
}
