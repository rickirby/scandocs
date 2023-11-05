//
//  CaptureSessionManager.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 29/10/23.
//

import UIKit
import CoreMotion
import AVFoundation
import SDScanKit

final class CaptureSessionManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let videoPreviewLayer: AVCaptureVideoPreviewLayer
    private let captureSession = AVCaptureSession()
    private let rectangleFunnel = RectangleFeaturesFunnel()
    weak var delegate: RectangleDetectionDelegateProtocol?
    private var displayedRectangleResult: RectangleDetectorResult?
    private var photoOutput = AVCapturePhotoOutput()
    
    private var isDetecting = true
    private var noRectangleCount = 0
    private let noRectangleThreshold = 3
    
    // MARK: Life Cycle
    
    init?(videoPreviewLayer: AVCaptureVideoPreviewLayer) {
        self.videoPreviewLayer = videoPreviewLayer
        super.init()
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            let error = CameraScannerControllerError.inputDevice
            delegate?.captureSessionManager(self, didFailWithError: error)
            return nil
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo
        
        photoOutput.isHighResolutionCaptureEnabled = true
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        defer {
            device.unlockForConfiguration()
            captureSession.commitConfiguration()
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(deviceInput),
            captureSession.canAddOutput(photoOutput),
            captureSession.canAddOutput(videoOutput) else {
                let error = CameraScannerControllerError.inputDevice
                delegate?.captureSessionManager(self, didFailWithError: error)
                return
        }
        
        do {
            try device.lockForConfiguration()
        } catch {
            let error = CameraScannerControllerError.inputDevice
            delegate?.captureSessionManager(self, didFailWithError: error)
            return
        }
        
        device.isSubjectAreaChangeMonitoringEnabled = true
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(photoOutput)
        captureSession.addOutput(videoOutput)
        
        videoPreviewLayer.session = captureSession
        videoPreviewLayer.videoGravity = .resizeAspectFill
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_ouput_queue"))
    }
    
    // MARK: Capture Session Life Cycle
    internal func start() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizationStatus {
        case .authorized:
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
            
            isDetecting = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (_) in
                DispatchQueue.main.async { [weak self] in
                    self?.start()
                }
            })
        default:
            let error = CameraScannerControllerError.authorization
            delegate?.captureSessionManager(self, didFailWithError: error)
        }
    }
    
    internal func stop() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.stopRunning()
        }
    }
    
    internal func capturePhoto() {
        guard let connection = photoOutput.connection(with: .video), connection.isEnabled, connection.isActive else {
            let error = CameraScannerControllerError.capture
            delegate?.captureSessionManager(self, didFailWithError: error)
            return
        }
        CaptureSession.current.setImageOrientation()
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isDetecting == true,
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
        }
        
        let imageSize = CGSize(width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
        VisionRectangleDetector.rectangle(forPixelBuffer: pixelBuffer) { [weak self] (rectangle) in
            self?.processRectangle(rectangle: rectangle, imageSize: imageSize)
        }
    }
    
    private func processRectangle(rectangle: Quadrilateral?, imageSize: CGSize) {
        if let rectangle = rectangle {
            
            self.noRectangleCount = 0
            self.rectangleFunnel.add(rectangle, currentlyDisplayedRectangle: self.displayedRectangleResult?.rectangle) { [weak self] (result, rectangle) in
                
                guard let strongSelf = self else {
                    return
                }
                
                let shouldAutoScan = (result == .showAndAutoScan)
                strongSelf.displayRectangleResult(rectangleResult: RectangleDetectorResult(rectangle: rectangle, imageSize: imageSize))
                if shouldAutoScan, CaptureSession.current.isAutoScanEnabled, !CaptureSession.current.isEditing {
                    capturePhoto()
                }
            }
            
        } else {
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.noRectangleCount += 1
                
                if strongSelf.noRectangleCount > strongSelf.noRectangleThreshold {
                    // Reset the currentAutoScanPassCount, so the threshold is restarted the next time a rectangle is found
                    strongSelf.rectangleFunnel.currentAutoScanPassCount = 0
                    
                    // Remove the currently displayed rectangle as no rectangles are being found anymore
                    strongSelf.displayedRectangleResult = nil
                    strongSelf.delegate?.captureSessionManager(strongSelf, didDetectQuad: nil, imageSize)
                }
            }
            return
        }
    }
    
    @discardableResult private func displayRectangleResult(rectangleResult: RectangleDetectorResult) -> Quadrilateral {
        displayedRectangleResult = rectangleResult
        
        let quad = rectangleResult.rectangle.toCartesian(withHeight: rectangleResult.imageSize.height)
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.delegate?.captureSessionManager(strongSelf, didDetectQuad: quad, rectangleResult.imageSize)
        }
        return quad
    }
}

extension CaptureSessionManager: AVCapturePhotoCaptureDelegate {
    
    // swiftlint:disable function_parameter_count
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        autoreleasepool {
            if let error = error {
                delegate?.captureSessionManager(self, didFailWithError: error)
                return
            }
            
            isDetecting = false
            rectangleFunnel.currentAutoScanPassCount = 0
            delegate?.didStartCapturingPicture(for: self)
            
            if let sampleBuffer = photoSampleBuffer,
                let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: nil) {
                completeImageCapture(with: imageData)
            } else {
                let error = CameraScannerControllerError.capture
                delegate?.captureSessionManager(self, didFailWithError: error)
                return
            }
        }
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        autoreleasepool {
            if let error = error {
                delegate?.captureSessionManager(self, didFailWithError: error)
                return
            }
            
            isDetecting = false
            rectangleFunnel.currentAutoScanPassCount = 0
            delegate?.didStartCapturingPicture(for: self)
            
            if let imageData = photo.fileDataRepresentation() {
                completeImageCapture(with: imageData)
            } else {
                let error = CameraScannerControllerError.capture
                delegate?.captureSessionManager(self, didFailWithError: error)
                return
            }
        }
    }
    
    private func completeImageCapture(with imageData: Data) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            CaptureSession.current.isEditing = true
            guard let image = UIImage(data: imageData) else {
                let error = CameraScannerControllerError.capture
                DispatchQueue.main.async {
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.delegate?.captureSessionManager(strongSelf, didFailWithError: error)
                }
                return
            }
            
            var angle: CGFloat = 0.0
            
            switch image.imageOrientation {
            case .right:
                angle = CGFloat.pi / 2
            case .up:
                angle = CGFloat.pi
            default:
                break
            }
            
            var quad: Quadrilateral?
            if let displayedRectangleResult = self?.displayedRectangleResult {
                quad = self?.displayRectangleResult(rectangleResult: displayedRectangleResult)
                quad = quad?.scale(displayedRectangleResult.imageSize, image.size, withRotationAngle: angle)
            }
            
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.captureSessionManager(strongSelf, didCapturePicture: image, withQuad: quad)
            }
        }
    }
}
