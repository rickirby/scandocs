//
//  SDScanAlbumsEmptyView.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 19/11/23.
//

import UIKit
import SDCoreKit

final class SDScanAlbumsEmptyView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "You don't have any documents"
        
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Tap camera button on top right to start scanning document."
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews([titleLabel, messageLabel])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
}
