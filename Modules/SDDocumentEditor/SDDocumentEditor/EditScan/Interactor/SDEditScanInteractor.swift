//
//  SDEditScanInteractor.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 24/10/23.
//

import UIKit
import Photos
import SDCloudKitModel
import SDScanKit

protocol ISDEditScanInteractor: AnyObject {
    func loadData()
    func loadDataAfterLayoutSubviews()
    func updateCurrentQuadrilateral(quad: Quadrilateral?)
    func tapAllAreaButton()
    func tapSaveButton()
    func tapNextButton()
}

final class SDEditScanInteractor: ISDEditScanInteractor {
    
    private let presenter: ISDEditScanPresenter
    private let image: UIImage
    private let rectanglePoint: RectanglePoint?
    private let documentGroup: DocumentGroup?
    private let currentDocument: Document?
    
    private var currentQuad: Quadrilateral?
    private var recentQuad: Quadrilateral?
    private var isAllAreaQuadSelected: Bool = false
    
    init(presenter: ISDEditScanPresenter, image: UIImage, rectanglePoint: RectanglePoint?, isRotateImage: Bool, documentGroup: DocumentGroup?, currentDocument: Document?) {
        self.presenter = presenter
        self.image = isRotateImage ? image.applyingPortraitOrientation() : image
        self.rectanglePoint = rectanglePoint
        self.documentGroup = documentGroup
        self.currentDocument = currentDocument
    }
    
    func loadData() {
        processImage()
    }
    
    func loadDataAfterLayoutSubviews() {
        processQuadrilateral()
    }
    
    func updateCurrentQuadrilateral(quad: Quadrilateral?) {
        currentQuad = quad
    }
    
    private func processImage() {
        presenter.displayImage(image: image)
    }
    
    private func processQuadrilateral() {
        let quadrilateral: Quadrilateral
        if let rectanglePoint {
            quadrilateral = Quadrilateral(rectanglePoint: rectanglePoint)
        } else {
            quadrilateral = Quadrilateral.defaultQuad(forImage: image)
        }
        
        updateCurrentQuadrilateral(quad: quadrilateral)
        presenter.displayQuadrilateral(quadrilateral: quadrilateral)
    }
    
    func tapAllAreaButton() {
        isAllAreaQuadSelected.toggle()
        
        if isAllAreaQuadSelected {
            recentQuad = currentQuad
            let newQuad: Quadrilateral = Quadrilateral.allFrameQuad(forImage: image)
            updateCurrentQuadrilateral(quad: newQuad)
            presenter.displayQuadrilateral(quadrilateral: newQuad)
        } else {
            guard let recentQuad else {
                return
            }
            
            updateCurrentQuadrilateral(quad: recentQuad)
            presenter.displayQuadrilateral(quadrilateral: recentQuad)
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
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
            
            self.presenter.showSuccessSavePhotoAlert()
        }
    }
    
    func tapNextButton() {
        guard let currentQuad else {
            return
        }
        
        presenter.navigateToPreview(image: image, quad: currentQuad, documentGroup: documentGroup, currentDocument: currentDocument)
    }
}
