//
//  SDEditScanViewController.swift
//  SDDocumentEditor
//
//  Created by Ricki Bin Yamin on 24/10/23.
//

import UIKit
import AVFoundation
import SDCoreKit
import SDScanKit
import SDCloudKitModel

protocol ISDEditScanViewController: AnyObject {
    func displayImage(image: UIImage)
    func displayQuadrilateral(quadrilateral: Quadrilateral)
    func showSuccessSavePhotoAlert()
    func showErrorSavePhotoAlert()
    func navigateToPreview(image: UIImage, quad: Quadrilateral, documentGroup: DocumentGroup?, currentDocument: Document?)
}

final class SDEditScanViewController: UIViewController, IScreenIdentifier {
    
    // MARK: - Public Properties
    
    var identifierName: ScreenIdentifierName {
        return .editScan
    }
    
    // MARK: - Private Properties
    
    private lazy var capturedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var quadView: QuadrilateralView = {
        let quadView = QuadrilateralView()
        quadView.editable = true
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()
    
    private lazy var nextBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextBarButtonTapped))
    
    private lazy var allAreaBarButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.and.arrow.up.right.and.arrow.down.left"), style: .plain, target: self, action: #selector(allAreaBarButtonTapped))
    
    private lazy var downloadBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(downloadBarButtonTapped))
    
    private lazy var quadViewWidthConstraint = NSLayoutConstraint()
    private lazy var quadViewHeightConstraint = NSLayoutConstraint()
    
    private var zoomGestureController: ZoomGestureController?
    private var image: UIImage? {
        didSet {
            capturedImageView.image = image
        }
    }
    
    private let interactor: ISDEditScanInteractor
    private let router: ISDEditScanRouter
    
    // MARK: - Life Cycles
    
    init(interactor: ISDEditScanInteractor, router: ISDEditScanRouter) {
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
        setupZoomGestureController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjustQuadViewConstraints()
        interactor.loadDataAfterLayoutSubviews()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        title = "Edit Document Points"
        view.backgroundColor = .systemBackground
        view.addSubviews([capturedImageView, quadView])
        
        quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
        quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)
        
        NSLayoutConstraint.activate([
            capturedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            capturedImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            capturedImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            capturedImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            quadView.centerXAnchor.constraint(equalTo: capturedImageView.centerXAnchor),
            quadView.centerYAnchor.constraint(equalTo: capturedImageView.centerYAnchor),
            quadViewWidthConstraint,
            quadViewHeightConstraint
        ])
    }
    
    private func setupNavigationBar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        navigationItem.rightBarButtonItems = [nextBarButton]
        toolbarItems = [downloadBarButton, spacer, allAreaBarButton]
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setLargeNavigationBarTitle(to: false)
    }
    
    private func adjustQuadViewConstraints() {
        guard let image = image else { return }
        let frame = AVMakeRect(aspectRatio: image.size, insideRect: capturedImageView.bounds)
        quadViewWidthConstraint.constant = frame.size.width
        quadViewHeightConstraint.constant = frame.size.height
    }
    
    private func setupZoomGestureController() {
        guard let image: UIImage = image else {
            return
        }
        
        zoomGestureController = ZoomGestureController(image: image, quadView: quadView)
        zoomGestureController?.configure(on: view)
        zoomGestureController?.delegate = self
    }
}

extension SDEditScanViewController {
    
    // MARK: - @objc target
    
    @objc func nextBarButtonTapped() {
        interactor.tapNextButton()
    }
    
    @objc func allAreaBarButtonTapped() {
        interactor.tapAllAreaButton()
    }
    
    @objc func downloadBarButtonTapped() {
        interactor.tapSaveButton()
    }
}

extension SDEditScanViewController: ISDEditScanViewController {
    func displayImage(image: UIImage) {
        self.image = image
    }
    
    func displayQuadrilateral(quadrilateral: Quadrilateral) {
        guard let image = image else {
            return
        }
        
        let imageSize = image.size
        let imageFrame = CGRect(origin: quadView.frame.origin, size: CGSize(width: quadViewWidthConstraint.constant, height: quadViewHeightConstraint.constant))
        
        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedQuad = quadrilateral.applyTransforms(transforms)
        
        quadView.drawQuadrilateral(quad: transformedQuad, animated: false)
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
    
    func navigateToPreview(image: UIImage, quad: Quadrilateral, documentGroup: DocumentGroup?, currentDocument: Document?) {
        router.navigateToPreview(image: image, quad: quad, documentGroup: documentGroup, currentDocument: currentDocument)
    }
}

extension SDEditScanViewController: ZoomGestureControllerDelegate {
    func zoomGestureController(_ controller: SDScanKit.ZoomGestureController, onUpdateQuad quad: Quadrilateral?) {
        interactor.updateCurrentQuadrilateral(quad: quad)
    }
}
