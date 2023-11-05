//
//  SDDocumentGroupInteractor.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 13/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel
import SDDatabaseWorker

protocol ISDDocumentGroupInteractor: AnyObject {
    func getData()
    func tapCameraButton()
    func tapFileButton()
    func selectItem(indexPath: IndexPath)
    func checkIfAnyMessageFromMessenger()
}

final class SDDocumentGroupInteractor: ISDDocumentGroupInteractor {
    
    private let presenter: ISDDocumentGroupPresenter
    private let databaseWorker: IDatabaseWorker
    private let documentGroup: DocumentGroup
    
    private var sortedDocuments: [Document] {
        guard let documents: [Document] = documentGroup.documents.allObjects as? [Document] else {
            return []
        }
        
        let sortedDocuments: [Document] = documents.sorted {
            $0.date.compare($1.date) == .orderedAscending
        }
        
        return sortedDocuments
    }
    
    init(presenter: ISDDocumentGroupPresenter, databaseWorker: IDatabaseWorker, documentGroup: DocumentGroup) {
        self.presenter = presenter
        self.databaseWorker = databaseWorker
        self.documentGroup = documentGroup
    }
    
    func getData() {
        presenter.distributeDocument(documents: sortedDocuments)
    }
    
    func tapCameraButton() {
        presenter.navigateToCamera(documentGroup: documentGroup)
    }
    
    func tapFileButton() {
        presenter.navigateToImagePicker(documentGroup: documentGroup)
    }
    
    func selectItem(indexPath: IndexPath) {
        presenter.navigateToPhotosGallery(documentGroup: documentGroup, initialSelectedIndex: indexPath.item)
    }
    
    func checkIfAnyMessageFromMessenger() {
        if let documentToDeleteFromGallery: Document = SDMessenger.shared.documentToDeleteFromGallery as? Document {
            databaseWorker.deleteDocument(documentToDelete: documentToDeleteFromGallery)
            presenter.distributeDocument(documents: sortedDocuments)
        }
        
        if let model: AddNewDocumentToDocumentGroupModel = SDMessenger.shared.modelToAddNewDocumentToDocumentGroup as? AddNewDocumentToDocumentGroupModel {
            databaseWorker.addDocumentToDocumentGroup(onDocumentGroup: model.documentGroup, originalImage: model.originalImage, thumbnailImage: model.thumbnailImage, rectanglePoint: model.rectanglePoint, rotationAngle: model.rotationAngle)
            presenter.distributeDocument(documents: sortedDocuments)
        }
        
        if let model: UpdateCurrentDocumentModel = SDMessenger.shared.modelToUpdateCurrentDocument as? UpdateCurrentDocumentModel {
            databaseWorker.updateDocument(onDocumentGroup: model.documentGroup, currentDocument: model.currentDocument, newRectanglePoint: model.newRectanglePoint, newRotationAngle: model.newRotationAngle, newThumbnailImage: model.newThumbnailImage)
            presenter.distributeDocument(documents: sortedDocuments)
        }
    }
}
