//
//  HomeDataProvider.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import CoreData
import SDCloudKitModel

protocol IHomeDataProvider: AnyObject {
    func getTableData() -> [String]
    func getDocumentGroup() -> DocumentGroup
}

final class HomeDataProvider: IHomeDataProvider {
    
    private let dummyDataCount: Int = 5
    private let mockManagedObjectContext: NSManagedObjectContext = setUpInMemoryManagedObjectContext()
    
    init() {
        makeDummyDocumentGroup()
    }
    
    func getTableData() -> [String] {
        var data: [String] = []
        for index in 1...dummyDataCount {
            data.append("Dummy Image \(index)")
        }
        
        return data
    }
    
    func getDocumentGroup() -> DocumentGroup {
        let fetchRequest: NSFetchRequest<DocumentGroup> = DocumentGroup.fetchRequest()
        let fetchedDocumentGroup: [DocumentGroup]? = try? mockManagedObjectContext.fetch(fetchRequest)
        
        guard let documentGroup: DocumentGroup = fetchedDocumentGroup?.first else {
            fatalError("Can not fetch dummy DocumentGroup object")
        }
        
        return documentGroup
    }
    
    private func makeDummyDocumentGroup() {
        var documents: [Document] = []
        
        for index in 1...dummyDataCount {
            guard
                let image = UIImage(named: "dummy\(index)"),
                let imageData: Data = image.jpegData(compressionQuality: 1)
            else {
                break
            }
            
            let documentImage: DocumentImage = DocumentImage(context: mockManagedObjectContext)
            documentImage.originalImage = imageData
            
            let quadPoint = QuadPoint(context: mockManagedObjectContext)
            quadPoint.topLeftX = 0
            quadPoint.topLeftY = 0
            quadPoint.topRightX = 0
            quadPoint.topRightY = 0
            quadPoint.bottomLeftX = 0
            quadPoint.bottomLeftY = 0
            quadPoint.bottomRightX = 0
            quadPoint.bottomRightY = 0
            
            let document: Document = Document(context: mockManagedObjectContext)
            document.image = documentImage
            document.thumbnail = imageData
            document.date = Date()
            document.rotationAngle = 0
            document.quad = quadPoint
            
            documents.append(document)
        }
        
        let documentGroup: DocumentGroup = DocumentGroup(context: mockManagedObjectContext)
        documentGroup.name = "Not Used"
        documentGroup.date = Date()
        documentGroup.documents = NSSet.init(array: documents)
        
        do {
            try mockManagedObjectContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
