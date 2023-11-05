//
//  SDScanAlbumsInteractor.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit
import Photos
import SDCoreKit
import SDCloudKitModel
import SDDatabaseWorker

protocol ISDScanAlbumsInteractor: AnyObject {
    func fetchData()
    func getFetchedDocumentGroup()
    func selectRow(at indexPath: IndexPath, isTableViewEditing: Bool)
    func deselectRow(isTableViewEditing: Bool, selectedIndexPaths: [IndexPath]?)
    func longPressTableView(at indexPath: IndexPath)
    func tapCameraButton()
    func tapSelectAllButton()
    func tapCancelButton()
    func tapDeleteButton(selectedIndexPaths: [IndexPath])
    func tapDeleteOnSwipe(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void)
    func tapMoreOnSwipe(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void)
    func tapDeleteOnMoreAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void)
    func tapSaveOnMoreAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void)
    func tapRenameOnMoreAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void)
    func confirmDeleteSelectedDocumentGroup(selectedIndexPaths: [IndexPath])
    func confirmRenameDocumentGroup(indexPath: IndexPath, newName: String)
    func checkIfAnyMessageFromMessenger()
}

final class SDScanAlbumsInteractor: ISDScanAlbumsInteractor {
    
    private let presenter: ISDScanAlbumsPresenter
    private let databaseWorker: IDatabaseWorker
    
    init(presenter: ISDScanAlbumsPresenter, databaseWorker: IDatabaseWorker) {
        self.presenter = presenter
        self.databaseWorker = databaseWorker
        self.databaseWorker.delegate = self
    }
    
    func fetchData() {
        databaseWorker.fetchData()
    }
    
    func getFetchedDocumentGroup() {
        guard let fetchedDocumentGroup: [DocumentGroup] = databaseWorker.fetchedDocumentGroup else {
            return
        }
        presenter.distributeFetchedDocumentGroup(documentGroup: fetchedDocumentGroup)
    }
    
    func selectRow(at indexPath: IndexPath, isTableViewEditing: Bool) {
        guard !isTableViewEditing else {
            return
        }
        
        let selectedDocumentGroup: DocumentGroup = databaseWorker.documentGroupObject(at: indexPath)
        presenter.navigateToDocumentPage(documentGroup: selectedDocumentGroup)
    }
    
    func deselectRow(isTableViewEditing: Bool, selectedIndexPaths: [IndexPath]?) {
        guard isTableViewEditing && selectedIndexPaths == nil else {
            return
        }
        
        presenter.setTableViewEditingState(isEditing: false)
    }
    
    func longPressTableView(at indexPath: IndexPath) {
        presenter.triggerHapticFeedback()
        presenter.setTableViewEditingState(isEditing: true)
        presenter.selectTableViewRow(indexPath: indexPath)
    }
    
    func tapCameraButton() {
        presenter.navigateToCamera()
    }
    
    func tapSelectAllButton() {
        guard let fetchedDocumentGroup: [DocumentGroup] = databaseWorker.fetchedDocumentGroup else {
            return
        }
        
        for index in 0 ..< fetchedDocumentGroup.count {
            let indexPath: IndexPath = IndexPath(row: index, section: 0)
            presenter.selectTableViewRow(indexPath: indexPath)
        }
    }
    
    func tapCancelButton() {
        presenter.setTableViewEditingState(isEditing: false)
    }
    
    func tapDeleteButton(selectedIndexPaths: [IndexPath]) {
        let isSingular: Bool = selectedIndexPaths.count == 1
        presenter.showDeleteDocumentGroupAlert(isSingular: isSingular, selectedIndexPaths: selectedIndexPaths)
    }
    
    func tapDeleteOnSwipe(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void) {
        presenter.showDeleteOnSwipeAlert(indexPath: indexPath, complete)
    }
    
    func tapMoreOnSwipe(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void) {
        presenter.showMoreOnSwipeAlert(indexPath: indexPath, complete)
    }
    
    func tapDeleteOnMoreAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void) {
        presenter.showDeleteOnSwipeAlert(indexPath: indexPath, complete)
    }
    
    func tapSaveOnMoreAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void) {
        complete(true)
        
        guard PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized else {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                if status == .authorized {
                    self.tapSaveOnMoreAlert(indexPath: indexPath, complete)
                } else {
                    self.presenter.showErrorSavePhotosAlert()
                }
            }
            
            return
        }
        
        let documentGroup: DocumentGroup = databaseWorker.documentGroupObject(at: indexPath)
        guard let documents: [Document] = documentGroup.documents.allObjects as? [Document] else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            for document in documents {
                guard let image: UIImage = UIImage(data: document.thumbnail) else {
                    return
                }
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
            self.presenter.showSuccessSavePhotosAlert(count: documents.count)
        }
    }
    
    func tapRenameOnMoreAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void) {
        complete(true)
        
        let documentGroup: DocumentGroup = databaseWorker.documentGroupObject(at: indexPath)
        let currentName: String = documentGroup.name
        
        presenter.showRenameOnSwipeAlert(indexPath: indexPath, currentName: currentName)
    }
    
    func confirmDeleteSelectedDocumentGroup(selectedIndexPaths: [IndexPath]) {
        var documentGroupToDelete: [DocumentGroup] = []
        
        for indexPath in selectedIndexPaths {
            documentGroupToDelete.append(databaseWorker.documentGroupObject(at: indexPath))
        }
        
        databaseWorker.deleteDocumentGroup(documentGroupToDelete: documentGroupToDelete)
        presenter.setTableViewEditingState(isEditing: false)
    }
    
    func confirmRenameDocumentGroup(indexPath: IndexPath, newName: String) {
        let documentGroup: DocumentGroup = databaseWorker.documentGroupObject(at: indexPath)
        
        databaseWorker.updateDocumentGroupName(onDocumentGroup: documentGroup, newName: newName)
    }
    
    func checkIfAnyMessageFromMessenger() {
        if let documentGroupToDeleteFromGallery: DocumentGroup = SDMessenger.shared.documentGroupToDeleteFromGallery as? DocumentGroup {
            databaseWorker.deleteDocumentGroup(documentGroupToDelete: documentGroupToDeleteFromGallery)
        }
        
        if let model: AddNewDocumentGroupModel = SDMessenger.shared.modelToAddNewDocumentGroup as? AddNewDocumentGroupModel {
            databaseWorker.addNewDocumentGroup(name: model.name, originalImage: model.originalImage, thumbnailImage: model.thumbnailImage, rectanglePoint: model.rectanglePoint, rotationAngle: model.rotationAngle)
        }
    }
}

extension SDScanAlbumsInteractor: DatabaseWorkerDelegate {
    func databaseWorkerBeginUpdates() {
        presenter.beginUpdates()
    }
    
    func databaseWorkerEndUpdates() {
        presenter.endUpdates()
    }
    
    func databaseWorkerInsertData(newIndexPath: IndexPath) {
        presenter.insertData(newIndexPath: newIndexPath)
    }
    
    func databaseWorkerDeleteData(indexPath: IndexPath) {
        presenter.deleteData(indexPath: indexPath)
    }
    
    func databaseWorkerUpdateData(indexPath: IndexPath) {
        presenter.updateData(indexPath: indexPath)
    }
    
    func databaseWorkerMoveData(indexPath: IndexPath, newIndexPath: IndexPath) {
        presenter.moveData(indexPath: indexPath, newIndexPath: newIndexPath)
    }
}
