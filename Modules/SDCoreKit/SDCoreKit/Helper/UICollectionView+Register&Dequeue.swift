//
//  UICollectionView+Register&Dequeue.swift
//  SDCoreKit
//
//  Created by Ricki Bin Yamin on 16/10/23.
//

import UIKit

public extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("\(String(describing: T.self)) is not registered yet")
        }
        
        return cell
    }
}
