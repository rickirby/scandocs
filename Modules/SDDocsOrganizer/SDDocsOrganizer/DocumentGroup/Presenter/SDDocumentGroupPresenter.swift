//
//  SDDocumentGroupPresenter.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 13/10/23.
//

import UIKit
import SDCloudKitModel

protocol ISDDocumentGroupPresenter: AnyObject {
    func distributeDocument(documents: [Document])
    func navigateToCamera(documentGroup: DocumentGroup)
    func navigateToImagePicker(documentGroup: DocumentGroup)
    func navigateToPhotosGallery(documentGroup: DocumentGroup, initialSelectedIndex: Int)
}

final class SDDocumentGroupPresenter: ISDDocumentGroupPresenter {
    
    weak var view: ISDDocumentGroupViewController?
    
    func distributeDocument(documents: [Document]) {
        view?.distributeDocument(documents: documents)
    }
    
    func navigateToCamera(documentGroup: DocumentGroup) {
        view?.navigateToCamera(documentGroup: documentGroup)
    }
    
    func navigateToImagePicker(documentGroup: DocumentGroup) {
        view?.navigateToImagePicker(documentGroup: documentGroup)
    }
    
    func navigateToPhotosGallery(documentGroup: DocumentGroup, initialSelectedIndex: Int) {
        view?.navigateToPhotosGallery(documentGroup: documentGroup, initialSelectedIndex: initialSelectedIndex)
    }
}
