//
//  SDDocsOrganizerEntryPoint.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 22/10/23.
//

import UIKit
import SDCoreKit

public extension BaseAppRouter {
    func navigateToScanAlbums() {
        presentModule(module: SDScanAlbumsModule.self, parameters: [:])
    }
}
