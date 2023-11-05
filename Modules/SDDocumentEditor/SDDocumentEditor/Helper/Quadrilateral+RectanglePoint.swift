//
//  Quadrilateral+RectanglePoint.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 24/10/23.
//

import UIKit
import SDCloudKitModel
import SDScanKit

extension Quadrilateral {
    init(rectanglePoint: RectanglePoint) {
        self.init(topLeft: rectanglePoint.topLeft, topRight: rectanglePoint.topRight, bottomRight: rectanglePoint.bottomRight, bottomLeft: rectanglePoint.bottomLeft)
    }
}

extension RectanglePoint {
    init(quadrilateral: Quadrilateral) {
        self.init(topLeft: quadrilateral.topLeft, topRight: quadrilateral.topRight, bottomRight: quadrilateral.bottomRight, bottomLeft: quadrilateral.bottomLeft)
    }
}
