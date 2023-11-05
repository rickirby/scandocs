//
//  SDPhotosGalleryEntryPoint.swift
//  SDPhotosGallery
//
//  Created by Ricki Bin Yamin on 22/10/23.
//

import UIKit
import SDCoreKit

public extension BaseAppRouter {
    func navigateToPhotosGallery(documentGroup: Any, initialSelectedIndex: Int) {
        let parameters: [String: Any] = [
            "documentGroup": documentGroup,
            "initialSelectedIndex": initialSelectedIndex
        ]
        
        presentModule(module: SDPhotosGalleryModule.self, parameters: parameters)
    }
}
