//
//  Document+CoreDataProperties.swift
//  SDCloudKitModel
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var date: Date
    @NSManaged public var rotationAngle: Double
    @NSManaged public var thumbnail: Data
    @NSManaged public var image: DocumentImage
    @NSManaged public weak var owner: DocumentGroup?
    @NSManaged public var quad: QuadPoint

}
