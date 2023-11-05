//
//  QuadPoint+CoreDataProperties.swift
//  SDCloudKitModel
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import Foundation
import CoreData


extension QuadPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuadPoint> {
        return NSFetchRequest<QuadPoint>(entityName: "QuadPoint")
    }

    @NSManaged public var bottomLeftX: Double
    @NSManaged public var bottomLeftY: Double
    @NSManaged public var bottomRightX: Double
    @NSManaged public var bottomRightY: Double
    @NSManaged public var topLeftX: Double
    @NSManaged public var topLeftY: Double
    @NSManaged public var topRightX: Double
    @NSManaged public var topRightY: Double
    @NSManaged public weak var owner: Document?

}
