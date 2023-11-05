//
//  SDDocumentGroupViewController.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 13/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel

protocol ISDDocumentGroupViewController: AnyObject {
    func distributeDocument(documents: [Document])
    func navigateToCamera(documentGroup: DocumentGroup)
    func navigateToImagePicker(documentGroup: DocumentGroup)
    func navigateToPhotosGallery(documentGroup: DocumentGroup, initialSelectedIndex: Int)
}

final class SDDocumentGroupViewController: UIViewController, IScreenIdentifier {
    
    // MARK: - Public Properties
    
    var identifierName: ScreenIdentifierName {
        return .documentGroup
    }
    
    // MARK: - Private Properties
    
    private let interactor: ISDDocumentGroupInteractor
    private let router: ISDDocumentGroupRouter
    private var documents: [Document] = []
    
    private lazy var collectionView: UICollectionView = {
        
        let screenWidth = UIScreen.main.bounds.width
        let cellSpacing: CGFloat = 10
        let contentInset: CGFloat = 20
        let cellSize = (screenWidth - 2 * contentInset) / 2 - cellSpacing
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumLineSpacing = screenWidth - 2 * (cellSize + contentInset)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: contentInset, left: contentInset, bottom: contentInset, right: contentInset)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: SDDocumentGroupCollectionViewCell.self)
        
        return collectionView
    }()
    
    private lazy var cameraBarButton = UIBarButtonItem(image: UIImage(systemName: "camera.on.rectangle"), style: .plain, target: self, action: #selector(cameraBarButtonTapped))
    
    private lazy var fileBarButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(fileBarButtonTapped))
    
    // MARK: - Life Cycles
    
    init(interactor: ISDDocumentGroupInteractor, router: ISDDocumentGroupRouter) {
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
        
        interactor.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setLargeNavigationBarTitle(to: false)
        setupBarButton()
        interactor.checkIfAnyMessageFromMessenger()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        title = "Documents"
        
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBarButton() {
        navigationItem.rightBarButtonItems = [cameraBarButton, fileBarButton]
        navigationController?.setToolbarHidden(true, animated: true)
    }
}

extension SDDocumentGroupViewController {
    
    // MARK: - @objc target
    
    @objc private func cameraBarButtonTapped() {
        interactor.tapCameraButton()
    }
    
    @objc private func fileBarButtonTapped() {
        interactor.tapFileButton()
    }
}

extension SDDocumentGroupViewController: ISDDocumentGroupViewController {
    func distributeDocument(documents: [Document]) {
        self.documents = documents
        collectionView.reloadData()
    }
    
    func navigateToCamera(documentGroup: DocumentGroup) {
        router.navigateToCamera(documentGroup: documentGroup)
    }
    
    func navigateToImagePicker(documentGroup: DocumentGroup) {
        router.navigateToImagePicker(documentGroup: documentGroup)
    }
    
    func navigateToPhotosGallery(documentGroup: DocumentGroup, initialSelectedIndex: Int) {
        router.navigateToPhotosGallery(documentGroup: documentGroup, initialSelectedIndex: initialSelectedIndex)
    }
}

extension SDDocumentGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object: Document = documents[indexPath.row]
        let cell: SDDocumentGroupCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: object)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.selectItem(indexPath: indexPath)
    }
}
