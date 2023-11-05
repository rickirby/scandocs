//
//  CameraScannerControllerError.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 29/10/23.
//

import Foundation

public enum CameraScannerControllerError: Error {
    case authorization
    case inputDevice
    case capture
    case ciImageCreation
}

extension CameraScannerControllerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .authorization:
            return "Failed to get the user's authorization for camera."
        case .inputDevice:
            return "Could not setup input device."
        case .capture:
            return "Could not capture pitcure."
        case .ciImageCreation:
            return "Internal Error - Could not create CIImage"
        }
    }
}
