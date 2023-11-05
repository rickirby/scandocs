//
//  RectangleDetectionDelegateProtocol.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 29/10/23.
//

import UIKit
import SDScanKit

protocol RectangleDetectionDelegateProtocol: NSObjectProtocol {
    
    func didStartCapturingPicture(for captureSessionManager: CaptureSessionManager)
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didDetectQuad quad: Quadrilateral?, _ imageSize: CGSize)
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didCapturePicture picture: UIImage, withQuad quad: Quadrilateral?)
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didFailWithError error: Error)
}
