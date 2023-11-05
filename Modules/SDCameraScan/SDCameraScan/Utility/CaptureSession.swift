//
//  CaptureSession.swift
//  SDCameraScan
//
//  Created by Ricki Bin Yamin on 29/10/23.
//


import UIKit
import AVFoundation
import CoreMotion

class CaptureSession {
    
    static let current = CaptureSession()
    var device: CaptureDevice?
    var isEditing: Bool
    var isAutoScanEnabled: Bool
    var editImageOrientation: CGImagePropertyOrientation
    
    private init(isAutoScanEnabled: Bool = false, editImageOrientation: CGImagePropertyOrientation = .up) {
        self.device = AVCaptureDevice.default(for: .video)
        self.isEditing = false
        self.isAutoScanEnabled = isAutoScanEnabled
        self.editImageOrientation = editImageOrientation
    }
}

extension CaptureSession {
    func setImageOrientation() {
        let motion = CMMotionManager()
        motion.accelerometerUpdateInterval = 0.01
        guard motion.isAccelerometerAvailable else { return }
        
        motion.startAccelerometerUpdates(to: OperationQueue()) { data, error in
            guard let data = data, error == nil else { return }
            let motionThreshold = 0.35
            
            if data.acceleration.x >= motionThreshold {
                self.editImageOrientation = .left
            } else if data.acceleration.x <= -motionThreshold {
                self.editImageOrientation = .right
            } else {
                self.editImageOrientation = .up
            }
            
            motion.stopAccelerometerUpdates()
            
            switch UIDevice.current.orientation {
            case .landscapeLeft:
                self.editImageOrientation = .right
            case .landscapeRight:
                self.editImageOrientation = .left
            default:
                break
            }
        }
    }
}

extension CaptureSession {
    enum FlashState {
        case on
        case off
        case unavailable
        case unknown
    }
    
    func toggleFlash() -> FlashState {
        guard let device = device, device.isTorchAvailable else { return .unavailable }
        
        do {
            try device.lockForConfiguration()
        } catch {
            return .unknown
        }
        
        defer {
            device.unlockForConfiguration()
        }
        
        if device.torchMode == .on {
            device.torchMode = .off
            return .off
        } else if device.torchMode == .off {
            device.torchMode = .on
            return .on
        }
        
        return .unknown
    }
    
    func setFlash(into state: AVCaptureDevice.TorchMode) {
        guard let device = device, device.isTorchAvailable else { return }
        
        do {
            try device.lockForConfiguration()
        } catch {
            return
        }
        
        defer {
            device.unlockForConfiguration()
        }
        
        device.torchMode = state
    }
}

extension CaptureSession {
    func setFocusPointToTapPoint(_ tapPoint: CGPoint) throws {
        guard let device = device else {
            let error = CameraScannerControllerError.inputDevice
            throw error
        }
        
        try device.lockForConfiguration()
        
        defer {
            device.unlockForConfiguration()
        }
        
        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.autoFocus) {
            device.focusPointOfInterest = tapPoint
            device.focusMode = .autoFocus
        }
        
        if device.isExposurePointOfInterestSupported, device.isExposureModeSupported(.continuousAutoExposure) {
            device.exposurePointOfInterest = tapPoint
            device.exposureMode = .continuousAutoExposure
        }
    }
    
    func resetFocusToAuto() throws {
        guard let device = device else {
            let error = CameraScannerControllerError.inputDevice
            throw error
        }
        
        try device.lockForConfiguration()
        
        defer {
            device.unlockForConfiguration()
        }
        
        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus) {
            device.focusMode = .continuousAutoFocus
        }
        
        if device.isExposurePointOfInterestSupported, device.isExposureModeSupported(.continuousAutoExposure) {
            device.exposureMode = .continuousAutoExposure
        }
    }
    
    func removeFocusRectangleIfNeeded(_ focusRectangle: FocusRectangleView?, animated: Bool) {
        guard let focusRectangle = focusRectangle else { return }
        if animated {
            UIView.animate(withDuration: 0.3, delay: 1.0, animations: {
                focusRectangle.alpha = 0.0
            }, completion: { (_) in
                focusRectangle.removeFromSuperview()
            })
        } else {
            focusRectangle.removeFromSuperview()
        }
    }
}
