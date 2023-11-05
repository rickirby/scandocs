//
//  DocumentImage+CoreDataProperties.swift
//  SDCloudKitModel
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import Foundation
import CoreData


extension DocumentImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentImage> {
        return NSFetchRequest<DocumentImage>(entityName: "DocumentImage")
    }

    @NSManaged public var originalImage: Data
    @NSManaged public weak var owner: Document?

}
