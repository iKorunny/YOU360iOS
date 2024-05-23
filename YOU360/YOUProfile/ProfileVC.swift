//
//  ProfileVC.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/1/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class ProfileVC: UIViewController {
    
    private enum Constants {
        static let backButtonInsets = UIEdgeInsets(top: 52, left: 20, bottom: 0, right: 0)
        static let moreButtonInsets = UIEdgeInsets(top: 52, left: 0, bottom: 0, right: 20)
        static let makePostButtonInsets = UIEdgeInsets(top: 0, left: 20, bottom: -16, right: -20)
    }
    
    private var viewModel: ProfileVCViewModel
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NavigationBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ProfileMenu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(toMore), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = ColorPallete.appWhiteSecondary
        return collection
    }()
    
    private lazy var refresher: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    private lazy var makePostButton: UIButton = {
        ButtonsFactory.createButton(
            backgroundColor: ColorPallete.appPink,
            highlightedBackgroundColor: ColorPallete.appDarkPink,
            title: "ProfileMakePostButtonTitle".localised(),
            titleColor: ColorPallete.appWhite,
            titleIcon: UIImage(named: "ProfileMakePostButtonIcon"),
            target: self,
            action: #selector(toMakePost)
        )
    }()
    
    init(viewModel: ProfileVCViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        view.backgroundColor = ColorPallete.appWhiteSecondary
        
        setupUI()
    }
    
    private func setupUI() {
        setupCollectionView()
        setupTopButtons()
        
        viewModel.set(collectionView: collectionView,
                      view: self,
                      postsDataSource: ProfileVCPostsDataSource(collectionView: collectionView),
                      relatedWindow: ProfileRouter.shared.rootProfileVC?.view.window,
                      refreshControl: refresher)
    }
    
    private func setupTopButtons() {
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.backButtonInsets.left).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.backButtonInsets.top).isActive = true
        backButton.isHidden = ((navigationController?.viewControllers ?? []).count == 1 || navigationController?.visibleViewController !== self)
        
        view.addSubview(moreButton)
        moreButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.moreButtonInsets.top).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.moreButtonInsets.right).isActive = true
        
        view.addSubview(makePostButton)
        makePostButton.isHidden = true
        makePostButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.makePostButtonInsets.left).isActive = true
        makePostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.makePostButtonInsets.right).isActive = true
        makePostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.makePostButtonInsets.bottom - (view.safeAreaInsets.bottom + (tabBarController?.tabBar.bounds.height ?? 0))).isActive = true
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc private func popBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func toMore() {
        viewModel.toMenu()
    }
    
    @objc private func toMakePost() {
        print("ProfileVC -> toMakePost")
        viewModel.onMakePost()
    }
}

extension ProfileVC: UIGestureRecognizerDelegate {
    
}

extension ProfileVC: ProfileVCView {
    func setMakePostButton(visible: Bool) {
        makePostButton.isHidden = !visible
    }
}
