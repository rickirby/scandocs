//
//  SDDocumentGroupCollectionViewCell.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 16/10/23.
//

import UIKit
import SDCloudKitModel

final class SDDocumentGroupCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .secondarySystemFill
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
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
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - Public Method
    
    func configure(with object: Document) {
        imageView.startShimmering()
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let thumbnailImage = UIImage(data: object.thumbnail) else { return }
            
            DispatchQueue.main.async {
                self.imageView.stopShimmering()
                self.imageView.image = thumbnailImage
            }
        }
    }
    
    func configure(with image: UIImage?) {
        imageView.backgroundColor = .clear
        imageView.image = image
    }
}
