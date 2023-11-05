//
//  SDScanAlbumsTableViewCell.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 10/10/23.
//

import UIKit
import SDCloudKitModel

class SDScanAlbumsTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var documentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .tertiaryLabel
        
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    
    private func setupViews() {
        backgroundColor = .systemBackground
        accessoryType = .disclosureIndicator
        
        contentView.addSubviews([previewImageView, documentLabel, dateLabel, numberLabel])
        
        NSLayoutConstraint.activate([
            previewImageView.heightAnchor.constraint(equalToConstant: 64),
            previewImageView.widthAnchor.constraint(equalToConstant: 64),
            previewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            previewImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            
            documentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            documentLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: documentLabel.bottomAnchor, constant: 3),
            dateLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 20),
            
            numberLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 3),
            numberLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 20),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Public Method
    
    func configure(with object: (title: String, subtitle: String, footnote: String, thumbnail: UIImage?)) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy/MM/dd' 'HH:mm"
        
        documentLabel.text = object.title
        dateLabel.text = object.subtitle
        numberLabel.text = object.footnote
        previewImageView.image = object.thumbnail
    }
}
