//
//  IDatabaseWorker.swift
//  SDCloudKitModel
//
//  Created by Ricki Bin Yamin on 10/10/23.
//

import UIKit
import SDCloudKitModel

public protocol IDatabaseWorker: AnyObject {
    var delegate: DatabaseWorkerDelegate? { get set }
    var fetchedDocumentGroup: [DocumentGroup]? { get }
    func fetchData()
    func documentGroupObject(at indexPath: IndexPath) -> DocumentGroup
    
    // MARK: - DocumentGroup
    func addNewDocumentGroup(name: String, originalImage: UIImage, thumbnailImage: UIImage, rectanglePoint: RectanglePoint, rotationAngle: Double)
    func deleteDocumentGroup(documentGroupToDelete documentGroup: DocumentGroup)
    func deleteDocumentGroup(documentGroupToDelete documentGroup: [DocumentGroup])
    func updateDocumentGroupName(onDocumentGroup documentGroup: DocumentGroup, newName: String)
    
    // MARK: - Document
    func addDocumentToDocumentGroup(onDocumentGroup documentGroup: DocumentGroup, originalImage: UIImage, thumbnailImage: UIImage, rectanglePoint: RectanglePoint, rotationAngle: Double)
    func deleteDocument(documentToDelete document: Document)
    func updateDocument(onDocumentGroup documentGroup: DocumentGroup, currentDocument: Document, newRectanglePoint: RectanglePoint?, newRotationAngle: Double?, newThumbnailImage: UIImage)
}
