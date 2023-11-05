//
//  SDImagePickerViewController.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 01/11/23.
//

import UIKit
import SDCoreKit
import SDScanKit

class SDImagePickerViewController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var router: ISDImagePickerRouter?
    var documentGroup: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        var detectedQuad: Quadrilateral?
        
        guard let ciImage = CIImage(image: image) else { return }
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(orientation.rawValue))
        VisionRectangleDetector.rectangle(forImage: ciImage, orientation: orientation) { [weak self] quad in
            detectedQuad = quad?.toCartesian(withHeight: orientedImage.extent.height)
            picker.dismiss(animated: true) {
                self?.router?.navigateToEditScan(image: image, quadrilateral: detectedQuad, documentGroup: self?.documentGroup)
            }
        }
    }
}

