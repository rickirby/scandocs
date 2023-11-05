//
//  SDPhotosGalleryPresenter.swift
//  SDPhotosGallery
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import SDCloudKitModel

protocol ISDPhotosGalleryPresenter: AnyObject {
    func distributeImagesData(images: [UIImage])
    func scrollToPhotos(index: Int, animated: Bool)
    func showSuccessSavePhotoAlert()
    func showErrorSavePhotoAlert()
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint, documentGroup: DocumentGroup, currentDocument: Document)
    func showDeleteAlert()
    func navigateBackToDocumentGroup()
    func navigateBackToScanAlbums()
}

final class SDPhotosGalleryPresenter: ISDPhotosGalleryPresenter {
    
    weak var view: ISDPhotosGalleryViewController?
    
    func distributeImagesData(images: [UIImage]) {
        view?.distributeImagesData(images: images)
    }
    
    func scrollToPhotos(index: Int, animated: Bool) {
        view?.scrollToPhotos(index: index, animated: animated)
    }
    
    func showSuccessSavePhotoAlert() {
        view?.showSuccessSavePhotoAlert()
    }
    
    func showErrorSavePhotoAlert() {
        view?.showErrorSavePhotoAlert()
    }
    
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint, documentGroup: DocumentGroup, currentDocument: Document) {
        view?.navigateToEditScan(image: image, rectanglePoint: rectanglePoint, documentGroup: documentGroup, currentDocument: currentDocument)
    }
    
    func showDeleteAlert() {
        view?.showDeleteAlert()
    }
    
    func navigateBackToDocumentGroup() {
        view?.navigateBackToDocumentGroup()
    }
    
    func navigateBackToScanAlbums() {
        view?.navigateBackToScanAlbums()
    }
}
