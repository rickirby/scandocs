//
//  HomeInteractor.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import SDCloudKitModel

protocol IHomeInteractor: AnyObject {
    func loadData()
    func selectTable(index: Int)
}

final class HomeInteractor: IHomeInteractor {
    
    private let presenter: IHomePresenter
    private let dataProvider: IHomeDataProvider
    
    init(presenter: IHomePresenter, dataProvider: IHomeDataProvider) {
        self.presenter = presenter
        self.dataProvider = dataProvider
    }
    
    func loadData() {
        let tableData: [String] = dataProvider.getTableData()
        presenter.distributeTableData(data: tableData)
    }
    
    func selectTable(index: Int) {
        let documentGroup: DocumentGroup = dataProvider.getDocumentGroup()
        presenter.navigateToPhotsGallery(documentGroup: documentGroup, initialSelectedIndex: index)
    }
}
