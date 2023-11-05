//
//  DatabaseWorker.swift
//  SDCloudKitModel
//
//  Created by Ricki Bin Yamin on 10/10/23.
//

import UIKit
import CoreData
import SDCloudKitModel

public final class DatabaseWorker: NSObject, IDatabaseWorker {
    
    public var delegate: DatabaseWorkerDelegate?
    public var fetchedDocumentGroup: [DocumentGroup]? {
        return fetchedResultsController.fetchedObjects
    }
    
    private let managedContext = CoreDataManager.shared.viewContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DocumentGroup> = {
        let fetchRequest = NSFetchRequest<DocumentGroup>(entityName: "DocumentGroup")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController<DocumentGroup>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: "rootCache")
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    public func fetchData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func documentGroupObject(at indexPath: IndexPath) -> DocumentGroup {
        return fetchedResultsController.object(at: indexPath)
    }
    
    public func addNewDocumentGroup(name: String, originalImage: UIImage, thumbnailImage: UIImage, rectanglePoint: RectanglePoint, rotationAngle: Double) {
        guard
            let originalImageData: Data = originalImage.jpegData(compressionQuality: 1),
            let thumbnailImageData: Data = thumbnailImage.jpegData(compressionQuality: 1)
        else {
            return
        }
        
        let image: DocumentImage = DocumentImage(context: managedContext)
        image.originalImage = originalImageData
        let quad: QuadPoint = rectanglePoint.createQuadPoint(managedContext: managedContext)
        
        let document: Document = Document(context: managedContext)
        document.image = image
        document.thumbnail = thumbnailImageData
        document.quad = quad
        document.rotationAngle = rotationAngle
        
        let documentGroup: DocumentGroup = DocumentGroup(context: managedContext)
        documentGroup.name = name
        
        let newDate: Date = Date()
        documentGroup.date = newDate
        document.date = newDate
        
        documentGroup.documents = NSSet.init(array: [document])
        
        saveManagedContext()
    }
    
    public func deleteDocumentGroup(documentGroupToDelete documentGroup: DocumentGroup) {
        managedContext.delete(documentGroup)
        
        saveManagedContext()
    }
    
    public func deleteDocumentGroup(documentGroupToDelete documentGroup: [DocumentGroup]) {
        documentGroup.forEach {
            managedContext.delete($0)
        }
        
        saveManagedContext()
    }
    
    public func updateDocumentGroupName(onDocumentGroup documentGroup: DocumentGroup, newName: String) {
        documentGroup.name = newName
        
        saveManagedContext()
    }
    
    public func addDocumentToDocumentGroup(onDocumentGroup documentGroup: DocumentGroup, originalImage: UIImage, thumbnailImage: UIImage, rectanglePoint: RectanglePoint, rotationAngle: Double) {
        guard
            let originalImageData: Data = originalImage.jpegData(compressionQuality: 1),
            let thumbnailImageData: Data = thumbnailImage.jpegData(compressionQuality: 1)
        else {
            return
        }
        
        let image: DocumentImage = DocumentImage(context: managedContext)
        image.originalImage = originalImageData
        let quad: QuadPoint = rectanglePoint.createQuadPoint(managedContext: managedContext)
        
        let document = Document(context: managedContext)
        document.image = image
        document.thumbnail = thumbnailImageData
        document.quad = quad
        document.rotationAngle = rotationAngle
        
        let newDate: Date = Date()
        documentGroup.date = newDate
        document.date = newDate
        
        documentGroup.addToDocuments(document)
        
        saveManagedContext()
    }
    
    public func deleteDocument(documentToDelete document: Document) {
        managedContext.delete(document)
        
        saveManagedContext()
    }
    
    public func updateDocument(onDocumentGroup documentGroup: DocumentGroup, currentDocument: Document, newRectanglePoint: RectanglePoint?, newRotationAngle: Double?, newThumbnailImage: UIImage) {
        guard let newThumbnailImageData: Data = newThumbnailImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        if let newRectanglePoint: RectanglePoint = newRectanglePoint {
            let newQuad: QuadPoint = newRectanglePoint.createQuadPoint(managedContext: managedContext)
            currentDocument.quad = newQuad
        }
        
        if let newRotationAngle: Double = newRotationAngle {
            currentDocument.rotationAngle = newRotationAngle
        }
        
        currentDocument.thumbnail = newThumbnailImageData
        
        let newDate: Date = Date()
        documentGroup.date = newDate
        currentDocument.date = newDate
        
        saveManagedContext()
    }
    
    private func saveManagedContext() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}

extension DatabaseWorker: NSFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.databaseWorkerBeginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                return
            }
            delegate?.databaseWorkerInsertData(newIndexPath: newIndexPath)
            
        case .delete:
            guard let indexPath = indexPath else {
                return
            }
            delegate?.databaseWorkerDeleteData(indexPath: indexPath)
            
        case .move:
            guard
                let indexPath = indexPath,
                let newIndexPath = newIndexPath
            else {
                return
            }
            delegate?.databaseWorkerMoveData(indexPath: indexPath, newIndexPath: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {
                return
            }
            delegate?.databaseWorkerUpdateData(indexPath: indexPath)
            
        @unknown default:
            break
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.databaseWorkerEndUpdates()
    }
}
