//
//  ZoomGestureController.swift
//  SDScanKit
//
//  Created by Ricki Bin Yamin on 25/10/23.
//

import UIKit
import AVFoundation

public protocol ZoomGestureControllerDelegate: AnyObject {
    func zoomGestureController(_ controller: ZoomGestureController, onUpdateQuad quad: Quadrilateral?)
}

public final class ZoomGestureController {
    
    public weak var delegate: ZoomGestureControllerDelegate?
    
    private let image: UIImage
    private let quadView: QuadrilateralView
    private var previousPanPosition: CGPoint?
    private var closestCorner: CornerPosition?
    
    public init(image: UIImage, quadView: QuadrilateralView) {
        self.image = image
        self.quadView = quadView
    }
    
    public func configure(on view: UIView) {
        let touchDown = UILongPressGestureRecognizer(target: self, action: #selector(handle(pan:)))
        touchDown.minimumPressDuration = 0
        view.addGestureRecognizer(touchDown)
    }
    
    @objc public func handle(pan: UIGestureRecognizer) {
        guard let drawnQuad = quadView.quad else {
            return
        }
        
        guard pan.state != .ended else {
            self.previousPanPosition = nil
            self.closestCorner = nil
            quadView.resetHighlightedCornerViews()
            return
        }
        
        let position = pan.location(in: quadView)
        
        let previousPanPosition = self.previousPanPosition ?? position
        let closestCorner = self.closestCorner ?? position.closestCornerFrom(quad: drawnQuad)
        
        let offset = CGAffineTransform(translationX: position.x - previousPanPosition.x, y: position.y - previousPanPosition.y)
        let cornerView = quadView.cornerViewForCornerPosition(position: closestCorner)
        let draggedCornerViewCenter = cornerView.center.applying(offset)
        
        quadView.moveCorner(cornerView: cornerView, atPoint: draggedCornerViewCenter)
        
        self.previousPanPosition = position
        self.closestCorner = closestCorner
        
        let imageScale = image.size.width / quadView.bounds.size.width
        
        let scaledDraggedCornerViewCenter = CGPoint(x: draggedCornerViewCenter.x * imageScale, y: draggedCornerViewCenter.y * imageScale)
        guard let zoomedImage = image.scaledImage(atPoint: scaledDraggedCornerViewCenter, scaleFactor: 2.5, targetSize: quadView.bounds.size) else {
            return
        }
        
        quadView.highlightCornerAtPosition(position: closestCorner, with: zoomedImage)
        
        let quad = quadView.quad?.scale(quadView.bounds.size, image.size)
        delegate?.zoomGestureController(self, onUpdateQuad: quad)
    }
    
}
