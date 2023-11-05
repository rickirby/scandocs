//
//  UIViewController+LargeNavigationBarTitle.swift
//  SDCoreKit
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit

public extension UIViewController {
    func setLargeNavigationBarTitle(to large: Bool) {
        navigationItem.largeTitleDisplayMode = large ? .always : .never
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
