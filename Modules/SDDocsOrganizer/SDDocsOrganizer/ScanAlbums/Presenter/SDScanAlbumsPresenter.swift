//
//  SDScanAlbumsPresenter.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit
import CoreData
import SDCloudKitModel

protocol ISDScanAlbumsPresenter: AnyObject {
    func distributeFetchedDocumentGroup(documentGroup: [DocumentGroup])
    func beginUpdates()
    func endUpdates()
    func insertData(newIndexPath: IndexPath)
    func deleteData(indexPath: IndexPath)
    func updateData(indexPath: IndexPath)
    func moveData(indexPath: IndexPath, newIndexPath: IndexPath)
    func selectTableViewRow(indexPath: IndexPath)
    func setTableViewEditingState(isEditing: Bool)
    func triggerHapticFeedback()
    func showDeleteDocumentGroupAlert(isSingular: Bool, selectedIndexPaths: [IndexPath])
    func showDeleteOnSwipeAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void)
    func showMoreOnSwipeAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void)
    func showRenameOnSwipeAlert(indexPath: IndexPath, currentName: String)
    func showSuccessSavePhotosAlert(count: Int)
    func showErrorSavePhotosAlert()
    func navigateToDocumentPage(documentGroup: DocumentGroup)
    func navigateToCamera()
}

final class SDScanAlbumsPresenter: ISDScanAlbumsPresenter {
    
    weak var view: ISDScanAlbumsViewController?
    
    func distributeFetchedDocumentGroup(documentGroup: [DocumentGroup]) {
        let tableData: [(title: String, subtitle: String, footnote: String, thumbnail: UIImage?)] = documentGroup.map {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = "yyyy/MM/dd' 'HH:mm"
            
            let documents = $0.documents.allObjects as? [Document]
            let sortedDocument = documents?.sorted {
                $0.date.compare($1.date) == .orderedAscending
            }
            var thumbnailImage: UIImage?
            if let lastDocument = sortedDocument?.last, let thumbnail = UIImage(data: lastDocument.thumbnail) {
                thumbnailImage = thumbnail
            }
            
            let title: String = $0.name
            let subtitle: String = dateFormatter.string(from: $0.date)
            let footnote: String = "\($0.documents.count) " + ($0.documents.count > 1 ? "pages" : "page")
            
            return (title: title, subtitle: subtitle, footnote: footnote, thumbnail: thumbnailImage)
        }
        
        view?.distributeFetchedDocumentGroup(tableData: tableData)
    }
    
    func beginUpdates() {
        view?.beginUpdates()
    }
    
    func endUpdates() {
        view?.endUpdates()
    }
    
    func insertData(newIndexPath: IndexPath) {
        view?.insertData(newIndexPath: newIndexPath)
    }
    
    func deleteData(indexPath: IndexPath) {
        view?.deleteData(indexPath: indexPath)
    }
    
    func updateData(indexPath: IndexPath) {
        view?.updateData(indexPath: indexPath)
    }
    
    func moveData(indexPath: IndexPath, newIndexPath: IndexPath) {
        view?.moveData(indexPath: indexPath, newIndexPath: newIndexPath)
    }
    
    func selectTableViewRow(indexPath: IndexPath) {
        view?.selectTableViewRow(indexPath: indexPath)
    }
    
    func setTableViewEditingState(isEditing: Bool) {
        view?.setTableViewEditingState(isEditing: isEditing)
    }
    
    func triggerHapticFeedback() {
        view?.triggerHapticFeedback()
    }
    
    func showDeleteDocumentGroupAlert(isSingular: Bool, selectedIndexPaths: [IndexPath]) {
        view?.showDeleteDocumentGroupAlert(isSingular: isSingular, selectedIndexPaths: selectedIndexPaths)
    }
    
    func showDeleteOnSwipeAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void) {
        view?.showDeleteOnSwipeAlert(indexPath: indexPath, complete)
    }
    
    func showMoreOnSwipeAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void) {
        view?.showMoreOnSwipeAlert(indexPath: indexPath, complete)
    }
    
    func showRenameOnSwipeAlert(indexPath: IndexPath, currentName: String) {
        view?.showRenameOnSwipeAlert(indexPath: indexPath, currentName: currentName)
    }
    
    func showSuccessSavePhotosAlert(count: Int) {
        view?.showSuccessSavePhotosAlert(count: count)
    }
    
    func showErrorSavePhotosAlert() {
        view?.showErrorSavePhotosAlert()
    }
    
    func navigateToDocumentPage(documentGroup: DocumentGroup) {
        view?.navigateToDocumentPage(documentGroup: documentGroup)
    }
    
    func navigateToCamera() {
        view?.navigateToCamera()
    }
}
