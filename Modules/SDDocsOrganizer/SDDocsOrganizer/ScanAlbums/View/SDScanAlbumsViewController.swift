//
//  SDScanAlbumsViewController.swift
//  SDDocsOrganizer
//
//  Created by Ricki Bin Yamin on 09/10/23.
//

import UIKit
import CoreData
import SDCoreKit
import SDCloudKitModel

protocol ISDScanAlbumsViewController: AnyObject {
    func distributeFetchedDocumentGroup(tableData: [(title: String, subtitle: String, footnote: String, thumbnail: UIImage?)])
    func beginUpdates()
    func endUpdates()
    func insertData(newIndexPath: IndexPath)
    func deleteData(indexPath: IndexPath)
    func updateData(indexPath: IndexPath)
    func moveData(indexPath: IndexPath, newIndexPath: IndexPath)
    func selectTableViewRow(indexPath: IndexPath)
    func setTableViewEditingState(isEditing: Bool)
    func triggerHapticFeedback()
    func showDeleteDocumentGroupAlert(isSingular: Bool, selectedIndexPaths: [IndexPath])
    func showDeleteOnSwipeAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void)
    func showMoreOnSwipeAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void)
    func showRenameOnSwipeAlert(indexPath: IndexPath, currentName: String)
    func showSuccessSavePhotosAlert(count: Int)
    func showErrorSavePhotosAlert()
    func navigateToDocumentPage(documentGroup: DocumentGroup)
    func navigateToCamera()
}

final class SDScanAlbumsViewController: UIViewController, IScreenIdentifier {
    
    // MARK: - Public Properties
    
    var identifierName: ScreenIdentifierName {
        return .scanAlbums
    }
    
    // MARK: - Private Properties
    
    private let interactor: ISDScanAlbumsInteractor
    private let router: ISDScanAlbumsRouter
    private var tableData: [(title: String, subtitle: String, footnote: String, thumbnail: UIImage?)] = []
    
    // MARK: - View Component
    
    private lazy var tableView: UITableView = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(tableViewLongPressed(_:)))
        gesture.minimumPressDuration = 0.5
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.addGestureRecognizer(gesture)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: SDScanAlbumsTableViewCell.self)
        
        return tableView
    }()
    
    private lazy var cameraBarButton = UIBarButtonItem(image: UIImage(systemName: "camera.on.rectangle"), style: .plain, target: self, action: #selector(cameraBarButtonTapped))
    
    private lazy var cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonTapped))
    
    private lazy var selectAllBarButton = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(selectAllBarButtonTapped))
    
    private lazy var deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonTapped))
    
    private var rightBarButtonItemsNormalState: [UIBarButtonItem] {
        return [cameraBarButton]
    }
    
    private var rightBarButtonItemsEditingState: [UIBarButtonItem] {
        return [selectAllBarButton]
    }
    
    private var leftBarButtonItemsNormalState: [UIBarButtonItem] {
        return []
    }
    
    private var leftBarButtonItemsEditingState: [UIBarButtonItem] {
        return [cancelBarButton]
    }
    
    // MARK: - Life Cycles
    
    init(interactor: ISDScanAlbumsInteractor, router: ISDScanAlbumsRouter) {
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
        
        interactor.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setLargeNavigationBarTitle(to: true)
        configureNavigationItemForNormalState()
        clearTableSelectionWhenReturningPage()
        interactor.checkIfAnyMessageFromMessenger()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        title = "Scan Albums"
        toolbarItems = [deleteBarButton]
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavigationItemForEditingState() {
        navigationItem.leftBarButtonItems = leftBarButtonItemsEditingState
        navigationItem.rightBarButtonItems = rightBarButtonItemsEditingState
        
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    private func configureNavigationItemForNormalState() {
        navigationItem.leftBarButtonItems = leftBarButtonItemsNormalState
        navigationItem.rightBarButtonItems = rightBarButtonItemsNormalState
        
        navigationController?.setToolbarHidden(true, animated: true)
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
    
    private func configureEmptyState() {
        let emptyView: SDScanAlbumsEmptyView = SDScanAlbumsEmptyView()
        emptyView.frame = CGRect(x: view.center.x, y: view.center.y, width: view.bounds.size.width, height: view.bounds.size.height)
        tableView.backgroundView = emptyView
    }
    
    private func clearEmptyState() {
        tableView.backgroundView = nil
    }
}

extension SDScanAlbumsViewController {
    
    // MARK: - @objc target
    
    @objc private func tableViewLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began && !tableView.isEditing {
            let point = gesture.location(in: tableView)
            guard let indexPath = tableView.indexPathForRow(at: point), let _ = tableView.cellForRow(at: indexPath) else {
                return
            }
            
            interactor.longPressTableView(at: indexPath)
        }
    }
    
    @objc private func cameraBarButtonTapped() {
        interactor.tapCameraButton()
    }
    
    @objc private func cancelBarButtonTapped() {
        interactor.tapCancelButton()
    }
    
    @objc private func selectAllBarButtonTapped() {
        interactor.tapSelectAllButton()
    }
    
    @objc private func deleteBarButtonTapped() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else {
            return
        }
        
        interactor.tapDeleteButton(selectedIndexPaths: selectedIndexPaths)
    }
}

extension SDScanAlbumsViewController: ISDScanAlbumsViewController {
    func distributeFetchedDocumentGroup(tableData: [(title: String, subtitle: String, footnote: String, thumbnail: UIImage?)]) {
        self.tableData = tableData
    }
    
    func beginUpdates() {
        tableView.beginUpdates()
    }
    
    func endUpdates() {
        tableView.endUpdates()
    }
    
    func insertData(newIndexPath: IndexPath) {
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func deleteData(indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func updateData(indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func moveData(indexPath: IndexPath, newIndexPath: IndexPath) {
        tableView.moveRow(at: indexPath, to: newIndexPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.tableView.reloadRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    func selectTableViewRow(indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    
    func setTableViewEditingState(isEditing: Bool) {
        if isEditing {
            tableView.setEditing(true, animated: true)
            configureNavigationItemForEditingState()
        } else {
            tableView.setEditing(false, animated: true)
            configureNavigationItemForNormalState()
        }
    }
    
    func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred()
    }
    
    func showDeleteDocumentGroupAlert(isSingular: Bool, selectedIndexPaths: [IndexPath]) {
        SDAlertView.createBarDeleteAlert(
            self,
            isSingular: isSingular,
            deleteHandler: { [weak self] in
                self?.interactor.confirmDeleteSelectedDocumentGroup(selectedIndexPaths: selectedIndexPaths)
            }
        )
    }
    
    func showDeleteOnSwipeAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void) {
        SDAlertView.createSwipeDeleteAlert(
            self,
            deleteHandler: { [weak self] in
                self?.interactor.confirmDeleteSelectedDocumentGroup(selectedIndexPaths: [indexPath])
            },
            cancelHandler: {
                complete(true)
            }
        )
    }
    
    func showMoreOnSwipeAlert(indexPath: IndexPath, _ complete: @escaping (Bool) -> Void) {
        SDAlertView.createSwipeMoreSheet(
            self,
            renameHandler: { [weak self] in
                self?.interactor.tapRenameOnMoreAlert(indexPath: indexPath, complete)
            },
            saveHandler: { [weak self] in
                self?.interactor.tapSaveOnMoreAlert(indexPath: indexPath, complete)
            },
            deleteHandler: { [weak self] in
                self?.interactor.tapDeleteOnMoreAlert(indexPath: indexPath, complete)
            },
            cancelHandler: {
                complete(true)
            }
        )
    }
    
    func showRenameOnSwipeAlert(indexPath: IndexPath, currentName: String) {
        SDAlertView.createRenameAlert(
            self,
            currentName: currentName,
            renameHandler: { [weak self] newName in
                self?.interactor.confirmRenameDocumentGroup(indexPath: indexPath, newName: newName)
            }
        )
    }
    
    func showSuccessSavePhotosAlert(count: Int) {
        DispatchQueue.main.async {
            SDAlertView.createSaveAllImageAlert(self, count: count)
        }
    }
    
    func showErrorSavePhotosAlert() {
        DispatchQueue.main.async {
            SDAlertView.createErrorSaveImageAlert(self)
        }
    }
    
    func navigateToDocumentPage(documentGroup: DocumentGroup) {
        router.navigateToDocumentPage(documentGroup: documentGroup)
    }
    
    func navigateToCamera() {
        router.navigateToCamera()
    }
}

extension SDScanAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor.getFetchedDocumentGroup()
        
        if tableData.count == 0 {
            configureEmptyState()
        } else {
            clearEmptyState()
        }
        
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object: (title: String, subtitle: String, footnote: String, thumbnail: UIImage?) = tableData[indexPath.row]
        let cell: SDScanAlbumsTableViewCell = tableView.dequeueReusableCell()
        cell.configure(with: object)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, complete in
            self?.interactor.tapDeleteOnSwipe(indexPath: indexPath, complete)
        }
        
        let moreAction: UIContextualAction = UIContextualAction(style: .normal, title: "More") { [weak self] _, _, complete in
            self?.interactor.tapMoreOnSwipe(indexPath: indexPath, complete)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, moreAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.selectRow(at: indexPath, isTableViewEditing: tableView.isEditing)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        interactor.deselectRow(isTableViewEditing: tableView.isEditing, selectedIndexPaths: tableView.indexPathsForSelectedRows)
    }
}
