//
//  SDCameraScanEntryPoint.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 29/10/23.
//

import UIKit
import SDCoreKit

public extension BaseAppRouter {
    func navigateToCamera(documentGroup: Any? = nil) {
        var parameters: [String: Any] = [:]
        
        if let documentGroup {
            parameters["documentGroup"] = documentGroup
        }
        
        presentModule(module: SDCameraModule.self, parameters: parameters)
    }
    
    func openImagePicker(documentGroup: Any? = nil) {
        var parameters: [String: Any] = [:]
        
        if let documentGroup {
            parameters["documentGroup"] = documentGroup
        }
        
        presentModule(module: SDImagePickerModule.self, parameters: parameters)
    }
}
