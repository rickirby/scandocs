//
//  HomeViewController.swift
//  ExampleApps
//
//  Created by Ricki Bin Yamin on 20/10/23.
//

import UIKit
import SDCoreKit

protocol IHomeViewController: AnyObject {
    func navigateToCamera()
}

final class HomeViewController: UIViewController {
    
    private lazy var startCameraButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Camera", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(startCameraButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let interactor: IHomeInteractor
    private let router: IHomeRouter
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setLargeNavigationBarTitle(to: false)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(startCameraButton)
        
        NSLayoutConstraint.activate([
            startCameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startCameraButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension HomeViewController {
    @objc private func startCameraButtonTapped() {
        interactor.tapStartCameraButton()
    }
}

extension HomeViewController: IHomeViewController {
    func navigateToCamera() {
        router.navigateToCamera()
    }
}
