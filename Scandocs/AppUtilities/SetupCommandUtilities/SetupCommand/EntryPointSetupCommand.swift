//
//  EntryPointSetupCommand.swift
//  Scandocs
//
//  Created by Ricki Bin Yamin on 22/10/23.
//

import Foundation
import SDDocsOrganizer

struct EntryPointSetupCommand: ISetupCommand {
    
    let scene: UIScene
    
    func execute() {
        AppRouter.scene = scene
        AppRouter.shared.navigateToScanAlbums()
    }
}
