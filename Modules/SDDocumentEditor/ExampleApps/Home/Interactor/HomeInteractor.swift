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
        guard let image: UIImage = dataProvider.getImage(at: index) else {
            return
        }
        
        let rectanglePoint: RectanglePoint? = dataProvider.getRectanglePoint(at: index)
        let documentGroup: DocumentGroup = dataProvider.getDocumentGroup()
        let document: Document? = dataProvider.getDocument(at: index)
        let isRotateImage: Bool = false
        
        presenter.navigateToEditScan(image: image, rectanglePoint: rectanglePoint, isRotateImage: isRotateImage, documentGroup: documentGroup, currentDocument: document)
    }
}
