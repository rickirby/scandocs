//
//  SDPhotosGalleryViewController.swift
//  SDPhotosGallery
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import SDCoreKit
import SDCloudKitModel

protocol ISDPhotosGalleryViewController: AnyObject {
    func distributeImagesData(images: [UIImage])
    func scrollToPhotos(index: Int, animated: Bool)
    func showSuccessSavePhotoAlert()
    func showErrorSavePhotoAlert()
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint, documentGroup: DocumentGroup, currentDocument: Document)
    func showDeleteAlert()
    func navigateBackToDocumentGroup()
    func navigateBackToScanAlbums()
}

final class SDPhotosGalleryViewController: UIViewController, IScreenIdentifier {
    
    // MARK: - Public Properties
    
    var identifierName: ScreenIdentifierName {
        return .photosGallery
    }
    
    // MARK: - Private Properties
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(cell: SDPhotosGalleryCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private lazy var editBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editBarButtonTapped))
    
    private lazy var downloadBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(downloadBarButtonTapped))
    
    private lazy var deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonTapped))
    
    private let interactor: ISDPhotosGalleryInteractor
    private let router: ISDPhotosGalleryRouter
    private var collectionData: [UIImage] = []
    
    // MARK: - Life Cycles
    
    init(interactor: ISDPhotosGalleryInteractor, router: ISDPhotosGalleryRouter) {
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
        
        setupNavigationBar()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -5),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let spacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        navigationItem.rightBarButtonItem = editBarButton
        toolbarItems = [downloadBarButton, spacer, deleteBarButton]
        navigationController?.setToolbarHidden(false, animated: true)
    }
}

extension SDPhotosGalleryViewController {
    
    // MARK: - @objc target
    
    @objc private func editBarButtonTapped() {
        interactor.tapEditButton()
    }
    
    @objc private func downloadBarButtonTapped() {
        interactor.tapSaveButton()
    }
    
    @objc private func deleteBarButtonTapped() {
        interactor.tapDeleteButton()
    }
}

extension SDPhotosGalleryViewController: ISDPhotosGalleryViewController {
    func distributeImagesData(images: [UIImage]) {
        collectionData = images
        collectionView.reloadData()
    }
    
    func scrollToPhotos(index: Int, animated: Bool) {
        DispatchQueue.main.async {
            self.collectionView.isPagingEnabled = false
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
            self.collectionView.isPagingEnabled = true
        }
    }
    
    func showSuccessSavePhotoAlert() {
        DispatchQueue.main.async {
            SDAlertView.createSaveImageAlert(self)
        }
    }
    
    func showErrorSavePhotoAlert() {
        DispatchQueue.main.async {
            SDAlertView.createErrorSaveImageAlert(self)
        }
    }
    
    func navigateToEditScan(image: UIImage, rectanglePoint: RectanglePoint, documentGroup: DocumentGroup, currentDocument: Document) {
        router.navigateToEditScan(image: image, rectanglePoint: rectanglePoint, documentGroup: documentGroup, currentDocument: currentDocument)
    }
    
    func showDeleteAlert() {
        SDAlertView.createGalleryDeleteAlert(
            self,
            deleteHandler: { [weak self] in
                self?.interactor.confirmDelete()
            }
        )
    }
    
    func navigateBackToDocumentGroup() {
        router.navigateBackToDocumentGroup()
    }
    
    func navigateBackToScanAlbums() {
        router.navigateBackToScanAlbums()
    }
}

extension SDPhotosGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SDPhotosGalleryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.image = collectionData[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newPageIndex: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        interactor.updateSelectedIndex(index: newPageIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension SDPhotosGalleryViewController: SDPhotosGalleryCollectionViewCellDelegate {
    
    func didZoomToOriginal() {
        collectionView.isScrollEnabled = true
    }
    
    func didZoomToScaled() {
        collectionView.isScrollEnabled = false
    }
}
