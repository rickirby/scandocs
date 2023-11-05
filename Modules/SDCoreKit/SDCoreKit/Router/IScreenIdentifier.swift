//
//  IScreenIdentifier.swift
//  SDCoreKit
//
//  Created by Ricki Bin Yamin on 29/10/23.
//

import UIKit

public enum ScreenIdentifierName {
    case scanAlbums
    case documentGroup
    case photosGallery
    case editScan
    case preview
}

public protocol IScreenIdentifier: AnyObject {
    var identifierName: ScreenIdentifierName { get }
}
