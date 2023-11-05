//
//  UIView+Subviews.swift
//  SDCoreKit
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
}
