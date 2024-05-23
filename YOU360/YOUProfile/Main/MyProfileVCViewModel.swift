//
//  MyProfileVCViewModel.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/8/24.
//

import Foundation
import YOUAuthorization
import UIKit
import YOUNetworking
import YOUUtils
import YOUUIComponents

enum ProfileTab {
    case content
    case places
    case events
    
    var icon: UIImage? {
        switch self {
        case .content:
            return UIImage(named: "ProfileContentTab")
        case .places:
            return UIImage(named: "ProfilePlacesTab")
        case .events:
            return UIImage(named: "ProfileEventsTab")
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .content:
            return UIImage(named: "ProfileContentTabSelected")
        case .places:
            return UIImage(named: "ProfilePlacesTabSelected")
        case .events:
            return UIImage(named: "ProfileEventsTabSelected")
        }
    }
    
    var title: String? {
        switch self {
        case .content:
            return "ProfileContentTab".localised()
        case .places:
            return "ProfilePlacesTab".localised()
        case .events:
            return "ProfileEventsTab".localised()
        }
    }
}

protocol MyProfileVCView: AnyObject {
    func setMakePostButton(visible: Bool)
}

protocol MyProfileVCViewModel {
    var myProfile: Bool { get }
    var isProfileFilled: Bool { get }
    
    func toMenu()
    func set(collectionView: UICollectionView,
             view: (UIViewController & MyProfileVCView),
             postsDataSource: ProfileVCPostsDataSource,
             relatedWindow: UIWindow?,
             refreshControl: UIRefreshControl)
    
    func onMakePost()
}

final class MyProfileVCViewModelImpl: NSObject, MyProfileVCViewModel {
    private enum Constants {
        static let profileHeaderId = "ProfileHeaderCell"
        static let profileEditCellId = "ProfileEditProfileCell"
        static let profileInfoCellId = "ProfileInfoCell"
        static let profileSocialButtonsCellId = "ProfileSocialButtonsCell"
        static let profileContentSegmentCellId = "ProfileContentSegmentCell"
        static let profileContentEmptyCellId = "ProfileContentEmptyCell"
        static let profileContentCellId = "ProfileContentCell"
        
        static let headerSectionIndex: Int = 0
        static let socialSectionIndex: Int = 1
        static let contentSegmentSectionIndex: Int = 2
        static let contentSectionIndex: Int = 3
        static let contentSectionOffset: CGFloat = 24
        
        static let contentSecionInteritemSpace: CGFloat = 10
        static let contentSectionLineOffset: CGFloat = 10
        static let contentCollectionOffset: CGFloat = 20
        static let contentCollectionItemsPerLine: Int = 3
        static let contentFooterHeight: CGFloat = 72
    }
    
    var myProfile: Bool { return true }
    var isProfileFilled: Bool { return profileManager.isProfileEdited }
    var profileHasSocial: Bool { return profileManager.profile?.hasSocial ?? false }
    
    private lazy var networkService = {
        ProfileNetworkService()
    }()
    
    private weak var collectionView: UICollectionView?
    private weak var view: (UIViewController & MyProfileVCView)?
    private weak var refreshControl: UIRefreshControl?
    private weak var relatedWindow: UIWindow?
    
    private let profileManager: ProfileManager
    private var postsDataSource: ProfileVCPostsDataSource?
    
    private var contentType: ProfileTab = .content
    
    private var avatarDataTask: URLSessionDataTask?
    private var bannerDataTask: URLSessionDataTask?
    
    private lazy var imagePicker: YOUImagePicker = {
       return YOUNativeImagePicker(delegate: self)
    }()
    
    private lazy var loaderManager: LoaderManager = {
        return LoaderManager()
    }()

    private lazy var profileHeaderViewModel: ProvileHeaderContentViewModel = {
        ProvileHeaderContentViewModel(
            profile: ProfileManager.shared.profile,
            onlineIdicator: OnlineIndicator(isHidden: true, status: .online),
            avatar: profileManager.avatar,
            banner: profileManager.banner) { [weak self] in
                self?.toEditProfile()
            } onShare: {
                print("MyProfileVCViewModelImpl -> OnShare")
            }

    }()
    
    private var headerCell: ProfileHeaderCell?
    
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
        super.init()
        loadImages()
    }
    
    private func loadImages() {
        let group = DispatchGroup()
        var shouldReloadHeader = false
        
        if let avatarUrlString = profileManager.profile?.avatar?.contentUrl {
            let avatarUrl = URL(string: avatarUrlString)
            group.enter()
            avatarDataTask = ContentLoaders.imageLoader.dataTaskToLoadImage(with: avatarUrl) { [weak self] image in
                self?.avatarDataTask = nil
                self?.profileManager.avatar = image
                self?.profileHeaderViewModel.avatar = image
                shouldReloadHeader = true
                group.leave()
            }
        }
        
        if let bannerUrlString = profileManager.profile?.background?.contentUrl {
            let bannerUrl = URL(string: bannerUrlString)
            group.enter()
            bannerDataTask = ContentLoaders.imageLoader.dataTaskToLoadImage(with: bannerUrl) { [weak self] image in
                self?.bannerDataTask = nil
                self?.profileManager.banner = image
                self?.profileHeaderViewModel.banner = image
                shouldReloadHeader = true
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard shouldReloadHeader else { return }
            self?.collectionView?.reloadSections([Constants.headerSectionIndex])
        }
    }
    
    func set(collectionView: UICollectionView,
             view: (UIViewController & MyProfileVCView),
             postsDataSource: ProfileVCPostsDataSource,
             relatedWindow: UIWindow?,
             refreshControl: UIRefreshControl) {
        
        self.collectionView = collectionView
        self.view = view
        self.postsDataSource = postsDataSource
        self.relatedWindow = relatedWindow
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        view.setMakePostButton(visible: self.isProfileFilled)
        
        collectionView.register(ProfileHeaderCell.self, forCellWithReuseIdentifier: Constants.profileHeaderId)
        collectionView.register(ProfileEditProfileCell.self, forCellWithReuseIdentifier: Constants.profileEditCellId)
        collectionView.register(ProfileInfoCell.self, forCellWithReuseIdentifier: Constants.profileInfoCellId)
        collectionView.register(ProfileSocialButtonsCell.self, forCellWithReuseIdentifier: Constants.profileSocialButtonsCellId)
        collectionView.register(ProfileContentSegmentCell.self, forCellWithReuseIdentifier: Constants.profileContentSegmentCellId)
        collectionView.register(ProfileContentEmptyCell.self, forCellWithReuseIdentifier: Constants.profileContentEmptyCellId)
        collectionView.register(ProfileContentCell.self, forCellWithReuseIdentifier: Constants.profileContentCellId)
        
        if isProfileFilled, let profile = profileManager.profile {
            reloadContent(with: profile)
        }
        
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fullReload), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    func onMakePost() {
        guard let view = view else { return }
        
        imagePicker.present(from: view, type: .contentImage)
    }
    
    private func infoViewModel(from pofile: UserInfoResponse?) -> ProfileInfoContentViewModel? {
        guard let profile = profileManager.profile else { return nil }
        
        let date = profile.dateOfBirth.flatMap { Formatters.dateFromString($0) }
        return ProfileInfoContentViewModel(name: profile.displayName,
                                           desciption: profile.aboutMe,
                                           address: profile.city, 
                                           dateOfBirth: date,
                                           isVerified: profile.verification == .verified)
    }
    
    private func socialsModel(from profile: UserInfoResponse?) -> ProfileSocialButtonContentViewModel? {
        guard let profile = profile else { return nil }
        var social: [ProfileSocialButtonModel] = []
        if let instagram = profile.instagram, let instagramUrl = URL(string: instagram) {
            social.append(ProfileSocialButtonModel(type: .instagram, url: instagramUrl))
        }
        
        if let facebook = profile.facebook, let facebookUrl = URL(string: facebook) {
            social.append(ProfileSocialButtonModel(type: .facebook, url: facebookUrl))
        }
        
        if let twitter = profile.twitter, let twitterUrl = URL(string: twitter) {
            social.append(ProfileSocialButtonModel(type: .x, url: twitterUrl))
        }
        
        guard !social.isEmpty else { return nil }
        return ProfileSocialButtonContentViewModel(socials: social) { url in
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    private func toEditProfile() {
        ProfileRouter.shared.toEditProfile { [weak self] didSelectAvatar, didSelectBanner, newAvatar, newBanner, hasChanges in
            guard let self, hasChanges else { return }
            if didSelectAvatar {
                profileHeaderViewModel.avatar = newAvatar
            }
            
            if didSelectBanner {
                profileHeaderViewModel.banner = newBanner
            }
            
            self.reloadUI()
        }
        profileManager.isProfileEdited = true
    }
    
    private func reloadUI() {
        collectionView?.reloadData()
        view?.setMakePostButton(visible: self.isProfileFilled)
    }

    func toMenu() {
        ProfileRouter.shared.toMenu {}
    }
    
    private func numberOfItems(for tab: ProfileTab) -> Int {
        switch tab {
        case .content:
            return postsDataSource?.numberOfPosts ?? 0
        case .events:
            return profileManager.profile?.likedEventsCount ?? 0
        case .places:
            return profileManager.profile?.establishmentsSubscriptionsCount ?? 0
        }
    }
    
    private func emptySectionText(for tab: ProfileTab) -> String? {
        switch tab {
        case .content:
            return "ProfileContentEmpty".localised()
        case .events:
            return "ProfileEventsEmpty".localised()
        case .places:
            return "ProfilePlacesEmpty".localised()
        }
    }
    
    private func reloadContent(with updatedProfile: UserInfoResponse) {
        guard updatedProfile.postsCount > 0 else {
            collectionView?.reloadSections([Constants.contentSectionIndex])
            return
        }
        postsDataSource?.reloadContent(userId: updatedProfile.id, page: RequestPage(offset: 0, size: updatedProfile.postsCount)) { [weak self] success, localError in
            if success {
                self?.collectionView?.reloadSections([Constants.contentSectionIndex])
            }
            else {
                guard let vc = self?.view else { return }
                if localError == .noInternet {
                    AlertsPresenter.presentNoInternet(from: vc)
                }
                else {
                    AlertsPresenter.presentSomethingWentWrongAlert(from: vc)
                }
            }
        }
    }
    
    @objc private func fullReload() {
        guard let profile = profileHeaderViewModel.profile else { return }
        refreshControl?.beginRefreshing()
        
        networkService.makeProfileRequest(id: profile.id) { [weak self] success, profile, localError in
            self?.refreshControl?.endRefreshing()
            guard success, let updatedProfile = profile else {
                self?.collectionView?.setContentOffset(CGPoint(x: 0, y: -(self?.collectionView?.safeAreaInsets.top ?? .zero)), animated: false)
                if let view = self?.view {
                    if localError == .noInternet {
                        AlertsPresenter.presentNoInternet(from: view)
                    }
                    else {
                        AlertsPresenter.presentSomethingWentWrongAlert(from: view)
                    }
                }
                return
            }
            
            self?.profileManager.profile = updatedProfile
            self?.collectionView?.reloadData()
            guard self?.isProfileFilled == true else { return }
            self?.reloadContent(with: updatedProfile)
            self?.loadImages()
        }
    }
}


extension MyProfileVCViewModelImpl: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isProfileFilled ? 4 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Constants.headerSectionIndex:
            return 1
        case Constants.socialSectionIndex:
            return isProfileFilled ? (profileHasSocial ? 2 : 1) : 1
        case Constants.contentSegmentSectionIndex:
            return isProfileFilled ? 1 : 0
        case Constants.contentSectionIndex:
            let contentNumber = numberOfItems(for: contentType)
            return (contentNumber == 0 ? 1 : contentNumber)
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == Constants.headerSectionIndex{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileHeaderId, for: indexPath) as! ProfileHeaderCell
            headerCell = cell

            cell.apply(viewModel: profileHeaderViewModel)
            return cell
        }
        else if indexPath.section == Constants.socialSectionIndex {
            switch indexPath.row {
            case 0:
                if !isProfileFilled {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileEditCellId, for: indexPath) as! ProfileEditProfileCell
                    cell.apply(viewModel: .init(onEdit: { [weak self] in
                        self?.toEditProfile()
                    }))
                    return cell
                }
                else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileInfoCellId, for: indexPath) as! ProfileInfoCell
                    if let model = infoViewModel(from: profileManager.profile) {
                        cell.apply(viewModel: model)
                    }
                    
                    return cell
                }
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileSocialButtonsCellId, for: indexPath) as! ProfileSocialButtonsCell
                if let model = socialsModel(from: profileManager.profile) {
                    cell.apply(viewModel: model)
                }
                
                return cell
            default:
                break
            }
        }
        
        if indexPath.section == Constants.contentSegmentSectionIndex {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileContentSegmentCellId, for: indexPath) as! ProfileContentSegmentCell
            
            cell.apply(viewModel: ProfileContentSegmentContentViewModel(tabs: [.content, .places, .events], selectedTab: contentType, onSelectTab: { [weak self] newTab in
                self?.contentType = newTab
                self?.collectionView?.reloadSections([Constants.contentSectionIndex])
            }))
            
            return cell
        }
        
        if indexPath.section == Constants.contentSectionIndex {
            let isEmptySection = numberOfItems(for: contentType) == 0
            if isEmptySection {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileContentEmptyCellId, for: indexPath) as! ProfileContentEmptyCell
                cell.apply(text: emptySectionText(for: contentType))
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileContentCellId, for: indexPath) as! ProfileContentCell
                cell.setup()
                if let model = postsDataSource?.cellModel(for: indexPath.row) {
                    model.cell = cell
                    cell.cellModel = model
                }
                return cell
            }
        }
            
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (relatedWindow ?? collectionView.window)?.bounds.width ?? .leastNormalMagnitude
        if indexPath.section == Constants.headerSectionIndex {
            let height = ProvileHeaderContentView.calculateHeight(from: width)
            return CGSize(width: width, height: height)
        }
        else if indexPath.section == Constants.socialSectionIndex {
            switch indexPath.row {
            case 0:
                if !isProfileFilled {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileEditCellId, for: indexPath) as! ProfileEditProfileCell
                    return CGSize(width: width, height: cell.height(with: width))
                }
                else {
                    guard let infoModel = infoViewModel(from: profileManager.profile) else { return CGSize.zero }
                    
                    return CGSize(width: width,
                                  height: ProfileInfoCell.calculateHeight(from: width, model: infoModel))
                }
            case 1:
                return CGSize(width: width, height: ProfileSocialButtonsCell.height())
            default:
                return .zero
            }
        }
        
        if indexPath.section == Constants.contentSegmentSectionIndex {
            return CGSize(width: width,
                          height: ProfileContentSegmentCell.height())
        }
        
        if indexPath.section == Constants.contentSectionIndex {
            if numberOfItems(for: contentType) == 0 {
                return CGSize(width: width,
                              height: ProfileContentEmptyCell.height(for: emptySectionText(for: contentType), with: width))
            }
            else {
                return ProfileContentCell.size(with: width,
                                               offset: Constants.contentCollectionOffset,
                                               interitemSpacing: Constants.contentSecionInteritemSpace,
                                               numbeOfItemsPerLine: Constants.contentCollectionItemsPerLine)
            }
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case Constants.contentSegmentSectionIndex:
            return Constants.contentSectionOffset
        case Constants.contentSectionIndex:
            return Constants.contentSectionLineOffset
        default: return CGFloat.leastNormalMagnitude
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case Constants.contentSectionIndex:
            return Constants.contentSecionInteritemSpace
        default: return CGFloat.leastNormalMagnitude
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = (relatedWindow ?? collectionView.window)?.bounds.width ?? .leastNormalMagnitude
        switch section {
        case Constants.contentSectionIndex:
            return CGSize(width: width, height: Constants.contentFooterHeight)
        default:
            return CGSize(width: width, height: .leastNormalMagnitude)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case Constants.contentSectionIndex:
            return UIEdgeInsets(top: 0, left: Constants.contentCollectionOffset, bottom: 0, right: Constants.contentCollectionOffset)
        default:
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == Constants.contentSectionIndex else { return }
        
        switch contentType {
        case .content:
            guard let selectedPost = postsDataSource?.postModel(for: indexPath.row) else { return }
            print("MyProfileVCViewModelImpl -> didSelect post: \(selectedPost.id)")
            
            
        default: 
            return
        }
    }
}

extension MyProfileVCViewModelImpl: YOUImagePickerDelegate {
    func didPick(image: UIImage?, type: YOUImagePickerType) {
        guard let image, let profile = profileManager.profile else { return }
        if let view = view?.tabBarController ?? view {
            loaderManager.addFullscreenLoader(for: view)
        }
        
        networkService.makeUploadImagePostRequest(id: profile.id,
                                                  image: image) { [weak self] success, localError in
            guard success else {
                self?.loaderManager.removeFullscreenLoader() { [weak self] _ in
                    if let view = self?.view {
                        if localError == .noInternet {
                            AlertsPresenter.presentNoInternet(from: view)
                        }
                        else {
                            AlertsPresenter.presentSomethingWentWrongAlert(from: view)
                        }
                    }
                }
                return
            }
            
            self?.networkService.makeProfileRequest(id: profile.id) { [weak self] success, profile, localError in
                guard success, let updatedProfile = profile else {
                    self?.loaderManager.removeFullscreenLoader() { [weak self] _ in
                        if let view = self?.view {
                            if localError == .noInternet {
                                AlertsPresenter.presentNoInternet(from: view)
                            }
                            else {
                                AlertsPresenter.presentSomethingWentWrongAlert(from: view)
                            }
                        }
                    }
                    return
                }
                
                self?.loaderManager.removeFullscreenLoader()
                self?.profileManager.applyUpdate(updatedProfile: updatedProfile)
                self?.collectionView?.reloadSections([Constants.contentSectionIndex])
                self?.reloadContent(with: updatedProfile)
            }
        }
    }
}
