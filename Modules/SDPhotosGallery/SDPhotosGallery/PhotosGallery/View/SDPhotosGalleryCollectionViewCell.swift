//
//  SDPhotosGalleryCollectionViewCell.swift
//  SDPhotosGallery
//
//  Created by Ricki Bin Yamin on 22/10/23.
//

import UIKit

protocol SDPhotosGalleryCollectionViewCellDelegate: AnyObject {
    func didZoomToOriginal()
    func didZoomToScaled()
    func didSingleTap()
    func didDoubleTap()
}

extension SDPhotosGalleryCollectionViewCellDelegate {
    func didSingleTap() {}
    func didDoubleTap() {}
}

class SDPhotosGalleryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(_:)))
        
        return tapRecognizer
    }()
    
    private lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler(_:)))
        tapRecognizer.numberOfTapsRequired = 2
        
        return tapRecognizer
    }()
    
    // MARK: - Public Method
    
    var image: UIImage? {
        didSet {
            configureImage(image: image)
        }
    }
    
    weak var delegate: SDPhotosGalleryCollectionViewCellDelegate?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    
    private func configureView() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        
        self.addGestureRecognizer(singleTapGestureRecognizer)
        self.addGestureRecognizer(doubleTapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            scrollView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func configureImage(image: UIImage?) {
        imageView.image = image
        imageView.sizeToFit()
        imageView.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }
    
    @objc private func singleTapHandler(_ sender: UITapGestureRecognizer) {
        delegate?.didSingleTap()
    }
    
    @objc private func doubleTapHandler(_ sender: UITapGestureRecognizer) {
        delegate?.didDoubleTap()
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let location = sender.location(in: imageView)
            let width = self.scrollView.bounds.width / scrollView.maximumZoomScale
            let height = self.scrollView.bounds.height / scrollView.maximumZoomScale
            let originX = location.x - (width / 2.0)
            let originY = location.y - (height / 2.0)
            
            let rectToZoom = CGRect(x: originX, y: originY, width: width, height: height)
            self.scrollView.zoom(to: rectToZoom, animated: true)
        }
    }
}

extension SDPhotosGalleryCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        if verticalPadding >= 0 {
            scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        } else {
            scrollView.contentSize = imageViewSize
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale == scrollView.minimumZoomScale {
            delegate?.didZoomToOriginal()
        } else {
            delegate?.didZoomToScaled()
        }
    }
}
