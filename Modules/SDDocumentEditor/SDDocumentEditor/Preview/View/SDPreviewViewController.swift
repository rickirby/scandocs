//
//  SDPreviewViewController.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 27/10/23.
//

import UIKit
import SDCoreKit

protocol ISDPreviewViewController: AnyObject {
    func startLoading()
    func stopLoading()
    func showProcessedImage(processedImage: UIImage)
    func showInsertDocumentGroupNameAlert()
    func showErrorSavePhotoAlert()
    func showSuccessSavePhotoAlert()
    func navigateBackToScanAlbums()
    func navigateBackToDocumentGroup()
}

final class SDPreviewViewController: UIViewController, IScreenIdentifier {
    
    // MARK: - Public Properties
    
    var identifierName: ScreenIdentifierName {
        return .preview
    }
    
    // MARK: - Private Properties
    
    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    lazy var doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBarButtonTapped))
    
    lazy var downloadBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(downloadBarButtonTapped))
    
    lazy var rotateRightBarButton = UIBarButtonItem(image: UIImage(systemName: "rotate.right"), style: .plain, target: self, action: #selector(rotateRightBarButtonTapped))
    
    private let interactor: ISDPreviewInteractor
    private let router: ISDPreviewRouter
    
    init(interactor: ISDPreviewInteractor, router: ISDPreviewRouter) {
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
        title = "Preview"
        view.backgroundColor = .systemBackground
        view.addSubviews([previewImageView, activityIndicator])
        
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            previewImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        navigationItem.rightBarButtonItem = doneBarButton
        toolbarItems = [downloadBarButton, spacer, rotateRightBarButton]
        navigationController?.setToolbarHidden(false, animated: true)
    }
}

extension SDPreviewViewController {
    
    // MARK: - @objc target
    
    @objc private func doneBarButtonTapped() {
        interactor.tapDoneButton()
    }
    
    @objc private func downloadBarButtonTapped() {
        interactor.tapSaveButton()
    }
    
    @objc private func rotateRightBarButtonTapped() {
        interactor.tapRotateRightButton()
    }
}

extension SDPreviewViewController: ISDPreviewViewController {
    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func showProcessedImage(processedImage: UIImage) {
        DispatchQueue.main.async {
            self.previewImageView.image = processedImage
        }
    }
    
    func showInsertDocumentGroupNameAlert() {
        DispatchQueue.main.async {
            SDAlertView.createAddNewScanAlbumAlert(self) { [weak self] documentGroupName in
                self?.interactor.confirmDocumentGroupNameFromAlert(documentGroupName: documentGroupName)
            }
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
    
    func navigateBackToScanAlbums() {
        DispatchQueue.main.async {
            self.router.navigateBackToScanAlbums()
        }
    }
    
    func navigateBackToDocumentGroup() {
        DispatchQueue.main.async {
            self.router.navigateBackToDocumentGroup()
        }
    }
}
