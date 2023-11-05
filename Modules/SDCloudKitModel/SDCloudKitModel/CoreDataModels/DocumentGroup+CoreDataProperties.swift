//
//  DocumentGroup+CoreDataProperties.swift
//  SDCloudKitModel
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import Foundation
import CoreData


extension DocumentGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentGroup> {
        return NSFetchRequest<DocumentGroup>(entityName: "DocumentGroup")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var documents: NSSet

}

// MARK: Generated accessors for documents
extension DocumentGroup {

    @objc(addDocumentsObject:)
    @NSManaged public func addToDocuments(_ value: Document)

    @objc(removeDocumentsObject:)
    @NSManaged public func removeFromDocuments(_ value: Document)

    @objc(addDocuments:)
    @NSManaged public func addToDocuments(_ values: NSSet)

    @objc(removeDocuments:)
    @NSManaged public func removeFromDocuments(_ values: NSSet)

}
