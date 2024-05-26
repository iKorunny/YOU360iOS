//
//  PostDetailsVC.swift
//  YOUProfile
//
//  Created by Andrei Tamila on 4/28/24.
//

import UIKit
import YOUUtils
import YOUNetworking
import YOUUIComponents

protocol PostDetailsInjection {
    var dataSource: PostsDataSource { get }
}

final class PostDetailsInjectionImpl: PostDetailsInjection {
    let dataSource: PostsDataSource
    
    init(dataSource: PostsDataSource) {
        self.dataSource = dataSource
    }
}

final class PostDetailsVC: UIViewController {
    
    let viewModel: PostDetailsViewModel
    let contentVC: PostDetailsContentVC
    let header: PostDetailsHeaderView
    let footer: PostDetailsFooterView
    
    var headerDynamicConstraints: [NSLayoutConstraint] = []
    var footerDynamicConstraints: [NSLayoutConstraint] = []
    
    init(viewModel: PostDetailsViewModel, injection: PostDetailsInjection) {
        self.viewModel = viewModel
        self.header = PostDetailsHeaderView()
        self.footer = PostDetailsFooterView()
        self.contentVC = PostDetailsContentVC(viewModel: PostDetailsContentViewModel(dataSource: injection.dataSource))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        addChild(contentVC)
        contentVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentVC.view)
        contentVC.didMove(toParent: self)

        header.translatesAutoresizingMaskIntoConstraints = false
        footer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        view.addSubview(footer)
        
        NSLayoutConstraint.activate([
            contentVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 84),
            footer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footer.heightAnchor.constraint(equalToConstant: 84),
        ])
        
        setHeader(visible: true, animated: false)
        setFooter(visible: true, animated: false)
    }
    
    func setHeader(visible: Bool, animated: Bool) {
        NSLayoutConstraint.deactivate(headerDynamicConstraints)
        
        let block = {
            if visible {
                self.headerDynamicConstraints.append(
                    self.header.topAnchor.constraint(equalTo: self.view.topAnchor)
                )
            }
            else {
                self.headerDynamicConstraints.append(
                    self.header.bottomAnchor.constraint(equalTo: self.view.topAnchor)
                )
            }
            NSLayoutConstraint.activate(self.headerDynamicConstraints)
        }
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                block()
            }
        }
        else {
            block()
        }
    }
    
    func setFooter(visible: Bool, animated: Bool) {
        NSLayoutConstraint.deactivate(footerDynamicConstraints)
        
        let block = {
            if visible {
                self.footerDynamicConstraints.append(
                    self.footer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                )
            }
            else {
                self.footerDynamicConstraints.append(
                    self.footer.topAnchor.constraint(equalTo: self.view.bottomAnchor)
                )
            }
            NSLayoutConstraint.activate(self.footerDynamicConstraints)
        }
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                block()
            }
        }
        else {
            block()
        }
    }
}

protocol PostDetailsViewModel {
    
}

final class PostDetailsViewModelImpl: PostDetailsViewModel {

}



protocol PostDetailsContentDataSource {
    
}

class PostDetailsContentViewModel: NSObject, UICollectionViewDataSource {
    
    let dataSource: PostsDataSource
    
    init(dataSource: PostsDataSource) {
        self.dataSource = dataSource
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.postsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostDetailsContentCell", for: indexPath) as? PostDetailsContentCell {
            if let postItem = dataSource.getPost(index: indexPath.row) {
                cell.setData(contentItem: postItem)
            }
            return cell
        }
        else {
            return PostDetailsContentCell()
        }
    }
    
    
}

final class PostDetailsContentCell: UICollectionViewCell {
    
    var contentItemView: UIView?
    
    func setupContentView() {
        guard let contentItemView else {
            return
        }
        
        contentItemView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentItemView)
        NSLayoutConstraint.activate([
            contentItemView.topAnchor.constraint(equalTo: topAnchor),
            contentItemView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentItemView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentItemView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }
    
    func setData(contentItem: PostItem) {
        switch contentItem.contentTypeFull {
        case .image:
            let imageView = RemoteContentImageView()
            contentItemView = imageView
            setupContentView()
            imageView.setImage(with: contentItem.contentUrl)
        default:
            break
        }
    }
}

final class PostDetailsContentVC: UIViewController {
    let viewModel: PostDetailsContentViewModel
    let collectionView: UICollectionView
    
    init(viewModel: PostDetailsContentViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(PostDetailsContentCell.self, forCellWithReuseIdentifier: String(describing: PostDetailsContentCell.self))
    }
}

extension PostDetailsContentVC: UICollectionViewDelegate {
    
}

extension PostDetailsContentVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}


final class PostDetailsHeaderView: UIView {
    
    private enum Constants {
        static let buttonSize: CGSize = .init(width: 24, height: 24)
        static let labelHeight: CGFloat = 22
        static let buttonInsets: UIEdgeInsets = .init(top: 25, left: 20, bottom: 25, right: 20)
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Left")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonTouchedUp), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(menuButtonTouchedUp), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var pageCounterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
        updateData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateData() {
        pageCounterLabel.text = "1 from 21"
    }
    
    private func setup() {
        addSubview(backButton)
        addSubview(moreButton)
        addSubview(pageCounterLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.buttonInsets.left),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.buttonInsets.bottom),
            backButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height),
            backButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width),
            
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.buttonInsets.left),
            moreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.buttonInsets.bottom),
            moreButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height),
            moreButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width),
            
            pageCounterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageCounterLabel.centerYAnchor.constraint(equalTo: moreButton.centerYAnchor),
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
        static let buttonInsets: UIEdgeInsets = .init(top: 25, left: 20, bottom: 25, right: 20)
    }
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "HeartEmpty")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(likeButtonTouchedUp), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Share")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(shareButtonTouchedUp), for: .touchUpInside)
        button.backgroundColor = .clear
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
            
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.buttonInsets.left),
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
