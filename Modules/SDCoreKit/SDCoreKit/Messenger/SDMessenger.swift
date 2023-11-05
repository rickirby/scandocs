//
//  SDMessenger.swift
//  Pods-Scandocs
//
//  Created by Ricki Bin Yamin on 28/10/23.
//

import UIKit

public final class SDMessenger {
    
    public static let shared: SDMessenger = SDMessenger()
    
    private init() {}
    
    private var _documentToDeleteFromGallery: Any?
    private var _documentGroupToDeleteFromGallery: Any?
    private var _modelToUpdateCurrentDocument: Any?
    private var _modelToAddNewDocumentToDocumentGroup: Any?
    private var _modelToAddNewDocumentGroup: Any?
    
    public var documentToDeleteFromGallery: Any? {
        set {
            _documentToDeleteFromGallery = newValue
        }
        
        get {
            let temp = _documentToDeleteFromGallery
            _documentToDeleteFromGallery = nil
            
            return temp
        }
    }
    
    public var documentGroupToDeleteFromGallery: Any? {
        set {
            _documentGroupToDeleteFromGallery = newValue
        }
        
        get {
            let temp = _documentGroupToDeleteFromGallery
            _documentGroupToDeleteFromGallery = nil
            
            return temp
        }
    }
    
    public var modelToUpdateCurrentDocument: Any? {
        set {
            _modelToUpdateCurrentDocument = newValue
        }
        
        get {
            let temp = _modelToUpdateCurrentDocument
            _modelToUpdateCurrentDocument = nil
            
            return temp
        }
    }
    
    public var modelToAddNewDocumentToDocumentGroup: Any? {
        set {
            _modelToAddNewDocumentToDocumentGroup = newValue
        }
        
        get {
            let temp = _modelToAddNewDocumentToDocumentGroup
            _modelToAddNewDocumentToDocumentGroup = nil
            
            return temp
        }
    }
    
    public var modelToAddNewDocumentGroup: Any? {
        set {
            _modelToAddNewDocumentGroup = newValue
        }
        
        get {
            let temp = _modelToAddNewDocumentGroup
            _modelToAddNewDocumentGroup = nil
            
            return temp
        }
    }
}
