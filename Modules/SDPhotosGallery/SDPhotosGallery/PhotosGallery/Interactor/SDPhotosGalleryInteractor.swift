//
//  SDPhotosGalleryInteractor.swift
//  SDPhotosGallery
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import Photos
import SDCoreKit
import SDCloudKitModel

protocol ISDPhotosGalleryInteractor: AnyObject {
    func loadData()
    func updateSelectedIndex(index: Int)
    func tapSaveButton()
    func tapEditButton()
    func tapDeleteButton()
    func confirmDelete()
}

final class SDPhotosGalleryInteractor: ISDPhotosGalleryInteractor {
    
    private let presenter: ISDPhotosGalleryPresenter
    private let documentGroup: DocumentGroup
    private var currentSelectedIndex: Int
    private var images: [UIImage] = []
    private var sortedDocuments: [Document] = []
    
    init(presenter: ISDPhotosGalleryPresenter, documentGroup: DocumentGroup, initialSelectedIndex: Int) {
        self.presenter = presenter
        self.documentGroup = documentGroup
        self.currentSelectedIndex = initialSelectedIndex
        
        guard let documents: [Document] = documentGroup.documents.allObjects as? [Document] else {
            return
        }
        
        sortedDocuments = documents.sorted {
            $0.date.compare($1.date) == .orderedAscending
        }
        
        images = sortedDocuments.compactMap {
            UIImage(data: $0.thumbnail)
        }
    }
    
    func loadData() {
        presenter.distributeImagesData(images: images)
        presenter.scrollToPhotos(index: currentSelectedIndex, animated: false)
    }
    
    func updateSelectedIndex(index: Int) {
        currentSelectedIndex = index
    }
    
    func tapSaveButton() {
        guard PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized else {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                if status == .authorized {
                    self.tapSaveButton()
                } else {
                    self.presenter.showErrorSavePhotoAlert()
                }
            }
            
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let image: UIImage = self.images[self.currentSelectedIndex]
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            self.presenter.showSuccessSavePhotoAlert()
        }
    }
    
    func tapEditButton() {
        let document: Document = sortedDocuments[currentSelectedIndex]
        let rectanglePoint: RectanglePoint = RectanglePoint(quadPoint: document.quad)
        guard let originalImage: UIImage = UIImage(data: document.image.originalImage) else {
            return
        }
        
        presenter.navigateToEditScan(image: originalImage, rectanglePoint: rectanglePoint, documentGroup: documentGroup, currentDocument: document)
    }
    
    func tapDeleteButton() {
        presenter.showDeleteAlert()
    }
    
    func confirmDelete() {
        if sortedDocuments.count > 1 {
            // If current sorted documents are more than 1, delete only selected document
            let documentToDelete: Document = sortedDocuments[currentSelectedIndex]
            SDMessenger.shared.documentToDeleteFromGallery = documentToDelete
            
            presenter.navigateBackToDocumentGroup()
        } else {
            // If current sorted document is only 1 left, delete the document group instead
            let documentGroupToDelete: DocumentGroup = documentGroup
            SDMessenger.shared.documentGroupToDeleteFromGallery = documentGroupToDelete
            
            presenter.navigateBackToScanAlbums()
        }
    }
}
