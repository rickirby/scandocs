//
//  HomeViewController.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel

protocol IHomeViewController: AnyObject {
    func distributeTableData(data: [String])
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint?, isRotateImage: Bool, documentGroup: DocumentGroup?, currentDocument: Document?)
}

final class HomeViewController: UIViewController {
    
    private let interactor: IHomeInteractor
    private let router: IHomeRouter
    
    private var tableData: [String] = []
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cell: HomeTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    init(interactor: IHomeInteractor, router: IHomeRouter) {
        self.interactor = interactor
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setLargeNavigationBarTitle(to: false)
        clearTableSelectionWhenReturningPage()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func clearTableSelectionWhenReturningPage() {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let transitionCoordinator = transitionCoordinator {
                transitionCoordinator.animate(alongsideTransition: { (context) in
                    self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }, completion: nil)
                
                transitionCoordinator.notifyWhenInteractionChanges { (context) in
                    if context.isCancelled {
                        self.tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
                    }
                }
            } else {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
}

extension HomeViewController: IHomeViewController {
    func distributeTableData(data: [String]) {
        tableData = data
        tableView.reloadData()
    }
    
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint?, isRotateImage: Bool, documentGroup: DocumentGroup?, currentDocument: Document?) {
        router.navigateToEditScan(image: image, rectanglePoint: rectanglePoint, isRotateImage: isRotateImage, documentGroup: documentGroup, currentDocument: currentDocument)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = tableView.dequeueReusableCell()
        cell.configure(title: tableData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.selectTable(index: indexPath.row)
    }
}
