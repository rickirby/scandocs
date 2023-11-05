//
//  DatabaseWorkerDelegate.swift
//  SDCloudKitModel
//
//  Created by Ricki Bin Yamin on 10/10/23.
//

import UIKit

public protocol DatabaseWorkerDelegate: AnyObject {
    func databaseWorkerBeginUpdates()
    func databaseWorkerEndUpdates()
    func databaseWorkerInsertData(newIndexPath: IndexPath)
    func databaseWorkerDeleteData(indexPath: IndexPath)
    func databaseWorkerUpdateData(indexPath: IndexPath)
    func databaseWorkerMoveData(indexPath: IndexPath, newIndexPath: IndexPath)
}
