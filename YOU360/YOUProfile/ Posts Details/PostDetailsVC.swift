//
//  PostDetailsVC.swift
//  YOUProfile
//
//  Created by Andrei Tamila on 4/28/24.
//

import UIKit
import YOUUtils

final class PostDetailsVC: UIViewController {
    
    let viewModel: PostDetailsViewModel
    
    init(viewModel: PostDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PostDetailsContentDataSource {

}

class PostDetailsContentViewModel: NSObject, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return PostDetailsContentCell()
    } 
    
    
}

final class PostDetailsContentCell: UICollectionViewCell {
    
}

final class PostDetailsContentVC: UIViewController, UICollectionViewDelegate {
    let viewModel: PostDetailsContentViewModel
    let collectionView: UICollectionView
    
    init(viewModel: PostDetailsContentViewModel) {
        self.viewModel = viewModel
        self.collectionView = UICollectionView(frame: CGRect.zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = viewModel
        
        collectionView.isPagingEnabled = true
        collectionView.register(PostDetailsContentCell.self, forCellWithReuseIdentifier: String(describing: PostDetailsContentCell.self))
    }
}


final class PostDetailsHeaderView: UIView {
    
    private enum Constants {
        static let buttonSize: CGSize = .init(width: 24, height: 24)
        static let labelHeight: CGFloat = 22
        static let buttonInsets: UIEdgeInsets = .init(top: 0, left: 20, bottom: 10, right: 20)
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ProfileMenu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonTouchedUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ProfileMenu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(menuButtonTouchedUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var pageCounterLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(backButton)
        addSubview(moreButton)
        addSubview(pageCounterLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.buttonInsets.left),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.buttonInsets.bottom),
            backButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height),
            backButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width),
            
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.buttonInsets.left),
            moreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.buttonInsets.bottom),
            moreButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height),
            moreButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width),
            
            pageCounterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageCounterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            pageCounterLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
        ])
        
        backgroundColor = ColorPallete.appBlackSecondary.withAlphaComponent(0.9)
    }
    
    @objc func backButtonTouchedUp() {
        
    }
    
    @objc func menuButtonTouchedUp() {
        
    }
}

final class PostDetailsFooterViewModel {
    
}

struct PostDetailsFooterViewData {
    let likesCount: Int
    let likedByMe: Bool
}

final class PostDetailsFooterView: UIView {
    private enum Constants {
        static let buttonSize: CGSize = .init(width: 24, height: 24)
        static let labelHeight: CGFloat = 22
        static let buttonInsets: UIEdgeInsets = .init(top: 0, left: 20, bottom: 10, right: 20)
    }
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ProfileMenu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(likeButtonTouchedUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ProfileMenu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(shareButtonTouchedUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(likeButton)
        addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.buttonInsets.left),
            likeButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.buttonInsets.top),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width),
            
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.buttonInsets.left),
            shareButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.buttonInsets.top),
            shareButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height),
            shareButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width),
        ])
        
        backgroundColor = ColorPallete.appBlackSecondary.withAlphaComponent(0.9)
    }
    
    private func setLiked(_ liked: Bool) {
        if liked {
            likeButton.setImage(UIImage(named: "HeartFilled"), for: .normal)
            likeButton.setTitleColor(ColorPallete.appPink, for: .normal)
        }
        else {
            likeButton.setImage(UIImage(named: "HeartEmpty"), for: .normal)
            likeButton.setTitleColor(ColorPallete.appDirtyWhite, for: .normal)
        }
    }
    
    private func updateData(_ viewData: PostDetailsFooterViewData) {
        likeButton.setTitle("\(viewData.likesCount)", for: .normal)
        setLiked(viewData.likedByMe)
    }
    
    @objc func likeButtonTouchedUp() {
        
    }
    
    @objc func shareButtonTouchedUp() {
        
    }
}

protocol PostDetailsViewModel {
    
}

final class PostDetailsViewModelImpl {
    
}
