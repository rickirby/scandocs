//
//  FirebaseSetupCommand.swift
//  Scandocs
//
//  Created by Ricki Bin Yamin on 19/11/23.
//

import Foundation
import FirebaseCore

struct FirebaseSetupCommand: ISetupCommand {
    func execute() {
        FirebaseApp.configure()
    }
}
