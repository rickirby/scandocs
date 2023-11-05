//
//  SDPreviewInteractor.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 27/10/23.
//

import UIKit
import Photos
import SDCoreKit
import SDCloudKitModel
import SDScanKit

protocol ISDPreviewInteractor: AnyObject {
    func loadData()
    func tapRotateRightButton()
    func tapSaveButton()
    func tapDoneButton()
    func confirmDocumentGroupNameFromAlert(documentGroupName: String)
}

final class SDPreviewInteractor: ISDPreviewInteractor {
    
    private let presenter: ISDPreviewPresenter
    private let image: UIImage
    private let quad: Quadrilateral
    private let documentGroup: DocumentGroup?
    private let currentDocument: Document?
    
    private var processedImage: UIImage?
    private var rotationAngle = Measurement<UnitAngle>(value: 0, unit: .degrees)
    
    init(presenter: ISDPreviewPresenter, image: UIImage, quad: Quadrilateral, documentGroup: DocumentGroup?, currentDocument: Document?) {
        self.presenter = presenter
        self.image = image
        self.quad = quad
        self.documentGroup = documentGroup
        self.currentDocument = currentDocument
    }
    
    func loadData() {
        presenter.startLoading()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let processedImage: UIImage = PerspectiveTransformer.applyTransform(to: self.image, withQuad: self.quad)
            
            self.presenter.showProcessedImage(processedImage: processedImage)
            self.presenter.stopLoading()
            self.processedImage = processedImage
        }
    }
    
    func tapRotateRightButton() {
        presenter.startLoading()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.rotationAngle.value += 90
            
            if self.rotationAngle.value == 360 {
                self.rotationAngle.value = 0
            }
            
            self.processedImage = self.processedImage?.rotated(by: Measurement<UnitAngle>(value: 90, unit: .degrees))
            
            guard let processedImage: UIImage = self.processedImage else {
                return
            }
            
            self.presenter.showProcessedImage(processedImage: processedImage)
            self.presenter.stopLoading()
        }
    }
    
    func tapSaveButton() {
        guard PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized else {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                if status == .authorized {
                    self.tapSaveButton()
                } else {
                    self.presenter.showErrorSavePhotoAlert()
                }
            }
            
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let processedImage: UIImage = self.processedImage else {
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil)
            
            self.presenter.showSuccessSavePhotoAlert()
        }
    }
    
    func tapDoneButton() {
        guard let processedImage else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let documentGroup: DocumentGroup = self.documentGroup {
                self.presenter.startLoading()
                if let currentDocument: Document = self.currentDocument {
                    // Should update current Document
                    let model: UpdateCurrentDocumentModel = UpdateCurrentDocumentModel(
                        documentGroup: documentGroup,
                        currentDocument: currentDocument,
                        newRectanglePoint: RectanglePoint(quadrilateral: self.quad),
                        newRotationAngle: self.rotationAngle.value,
                        newThumbnailImage: processedImage
                    )
                    
                    SDMessenger.shared.modelToUpdateCurrentDocument = model
                } else {
                    // Should add Document to DocumentGroup
                    let model: AddNewDocumentToDocumentGroupModel = AddNewDocumentToDocumentGroupModel(
                        documentGroup: documentGroup,
                        originalImage: self.image,
                        thumbnailImage: processedImage,
                        rectanglePoint: RectanglePoint(quadrilateral: self.quad),
                        rotationAngle: self.rotationAngle.value
                    )
                    
                    SDMessenger.shared.modelToAddNewDocumentToDocumentGroup = model
                }
                
                self.presenter.stopLoading()
                self.presenter.navigateBackToDocumentGroup()
            } else {
                // Should show alert to insert new DocumentGroup name
                self.presenter.showInsertDocumentGroupNameAlert()
            }
        }
    }
    
    func confirmDocumentGroupNameFromAlert(documentGroupName: String) {
        guard let processedImage else {
            return
        }
        
        presenter.startLoading()
        
        DispatchQueue.global(qos: .background).async {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = "yyyy/MM/dd' 'HH:mm"
            
            let model: AddNewDocumentGroupModel = AddNewDocumentGroupModel(
                name: documentGroupName.isEmpty ? "Document \(dateFormatter.string(from: Date()))" : documentGroupName,
                originalImage: self.image,
                thumbnailImage: processedImage,
                rectanglePoint: RectanglePoint(quadrilateral: self.quad),
                rotationAngle: self.rotationAngle.value
            )
            
            SDMessenger.shared.modelToAddNewDocumentGroup = model
            self.presenter.stopLoading()
            self.presenter.navigateBackToScanAlbums()
        }
    }
}
