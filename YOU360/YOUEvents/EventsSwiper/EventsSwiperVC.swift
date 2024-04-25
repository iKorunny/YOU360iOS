//
//  EventsSwiperVC.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/20/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class EventsSwiperVC: UIViewController {
    
    private enum Constants {
        static let logoNavBarSize: CGSize = .init(width: 72, height: 24)
        static let rightNavigationButtonsViewSize = CGSize(width: 88, height: 44)
    }
    
    private lazy var searchNavigationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NavigationSearch")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(toSearch), for: .touchUpInside)
        return button
    }()
    
    private lazy var menuNavigationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NavigationMenuVertical")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(toMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightNavigationBarView: UIView = {
        let stackView = UIStackView(arrangedSubviews: [searchNavigationButton, menuNavigationButton])
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.frame = CGRect(origin: .zero, size: Constants.rightNavigationButtonsViewSize)
        
        return stackView
    }()
    
    private lazy var waitingAccessToGPSView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        
        let imageView = UIImageView(image: .init(named: "LOGOYOU360"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        contentView.isHidden = true
        return contentView
    }()
    
    private lazy var accessToGPSDeniedView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        
        
        let button = UIButton()
        button.setTitle("LocationAccessDeniedToSettingsButtonTitle".localised(), for: .normal)
        button.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.isHidden = true
        return contentView
    }()
    
    private lazy var accessToGPSGrantedView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        
        contentView.isHidden = true
        return contentView
    }()
    
    private lazy var contentVC: EventsSwiperContentVC = {
        let vc = EventsSwiperContentVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private lazy var loaderManager: LoaderManager = {
        return LoaderManager()
    }()
    
    private let viewModel: EventsSwiperViewModel
    
    init(viewModel: EventsSwiperViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.set(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.onViewDidLoad()
    }
    
    private func configureNavigation() {
        navigationItem.setLeftBarButton(UIBarButtonItem(
            image: UIImage(named: "LOGOYOU360")?.imageWith(newSize: Constants.logoNavBarSize).withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: nil,
            action: nil),
                                        animated: false)
        
        navigationItem.setRightBarButton(.init(customView: rightNavigationBarView), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.onViewWillAppear()
    }
    
    private func setupUI() {
        configureNavigation()
        
        setupColors()
        
        view.addSubview(waitingAccessToGPSView)
        waitingAccessToGPSView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        waitingAccessToGPSView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        waitingAccessToGPSView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        waitingAccessToGPSView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(accessToGPSDeniedView)
        accessToGPSDeniedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        accessToGPSDeniedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        accessToGPSDeniedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        accessToGPSDeniedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(accessToGPSGrantedView)
        accessToGPSGrantedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        accessToGPSGrantedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        accessToGPSGrantedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        accessToGPSGrantedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        contentVC.willMove(toParent: self)
        accessToGPSGrantedView.addSubview(contentVC.view)
        contentVC.view.leadingAnchor.constraint(equalTo: accessToGPSGrantedView.leadingAnchor).isActive = true
        contentVC.view.trailingAnchor.constraint(equalTo: accessToGPSGrantedView.trailingAnchor).isActive = true
        contentVC.view.topAnchor.constraint(equalTo: accessToGPSGrantedView.topAnchor).isActive = true
        contentVC.view.bottomAnchor.constraint(equalTo: accessToGPSGrantedView.bottomAnchor).isActive = true
        addChild(contentVC)
        contentVC.didMove(toParent: self)
    }
    
    private func setupColors() {
        view.backgroundColor = ColorPallete.appWhiteSecondary
        accessToGPSGrantedView.backgroundColor = ColorPallete.appWhiteSecondary
        accessToGPSDeniedView.backgroundColor = ColorPallete.appWhiteSecondary
        waitingAccessToGPSView.backgroundColor = ColorPallete.appWhiteSecondary
    }
    
    @objc private func goToSettings() {
        viewModel.onToSettings()
    }
    
    @objc private func toMenu() {
        viewModel.onToMenu()
    }
    
    @objc private func toSearch() {
        viewModel.onToSearch()
    }
}

extension EventsSwiperVC: EventsSwiperView {
    func onLocationStatusChanged(newStatus: YOULocationManagerAccessStatus) {
        switch newStatus {
        case .unknown:
            waitingAccessToGPSView.isHidden = false
            accessToGPSDeniedView.isHidden = true
            accessToGPSGrantedView.isHidden = true
        case .granted:
            waitingAccessToGPSView.isHidden = true
            accessToGPSDeniedView.isHidden = true
            accessToGPSGrantedView.isHidden = false
            reload(with: viewModel.dataModels)
        case .denied:
            waitingAccessToGPSView.isHidden = true
            accessToGPSDeniedView.isHidden = false
            accessToGPSGrantedView.isHidden = true
        }
    }
    
    func reload(with models: [EventsSwiperBussiness]) {
        contentVC.clean()
        contentVC.dataSource = EventsSwiperContentVCDataSourceImpl(with: models)
        contentVC.reload()
    }
    
    func runActivity() {
        loaderManager.addFullscreenLoader(for: self.tabBarController ?? self)
    }
    
    func stopActivity(completion: @escaping (() -> Void)) {
        loaderManager.removeFullscreenLoader { _ in
            completion()
        }
    }
}
