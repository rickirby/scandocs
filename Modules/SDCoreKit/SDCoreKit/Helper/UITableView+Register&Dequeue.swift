//
//  UITableView+Register&Dequeue.swift
//  SDCoreKit
//
//  Created by Ricki Bin Yamin on 10/10/23.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(cell: T.Type) {
        register(cell, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("\(String(describing: T.self)) is not registered yet")
        }
        
        return cell
    }
}
