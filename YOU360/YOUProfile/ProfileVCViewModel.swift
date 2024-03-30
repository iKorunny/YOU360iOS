//
//  ProfileVCViewModel.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/8/24.
//

import Foundation
import YOUProfileInterfaces
import UIKit

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

protocol ProfileVCView: AnyObject {
    func setMakePostButton(visible: Bool)
}

protocol ProfileVCViewModel {
    var myProfile: Bool { get }
    var isProfileFilled: Bool { get }
    
    func set(collectionView: UICollectionView, view: ProfileVCView)
}

final class MyProfileVCViewModelImpl: NSObject, ProfileVCViewModel {
    private enum Constants {
        static let profileHeaderId = "ProfileHeaderCell"
        static let profileEditCellId = "ProfileEditProfileCell"
        static let profileInfoCellId = "ProfileInfoCell"
        static let profileSocialButtonsCellId = "ProfileSocialButtonsCell"
        static let profileContentSegmentCellId = "ProfileContentSegmentCell"
        static let profileContentEmptyCellId = "ProfileContentEmptyCell"
        static let profileContentCellId = "ProfileContentCell"
        
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
    
    private weak var collectionView: UICollectionView?
    private weak var view: ProfileVCView?
    
    private var profileManager: ProfileManager
    
    private var contentType: ProfileTab = .content
    
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    func set(collectionView: UICollectionView, view: ProfileVCView) {
        self.collectionView = collectionView
        self.view = view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(ProfileHeaderCell.self, forCellWithReuseIdentifier: Constants.profileHeaderId)
        collectionView.register(ProfileEditProfileCell.self, forCellWithReuseIdentifier: Constants.profileEditCellId)
        collectionView.register(ProfileInfoCell.self, forCellWithReuseIdentifier: Constants.profileInfoCellId)
        collectionView.register(ProfileSocialButtonsCell.self, forCellWithReuseIdentifier: Constants.profileSocialButtonsCellId)
        collectionView.register(ProfileContentSegmentCell.self, forCellWithReuseIdentifier: Constants.profileContentSegmentCellId)
        collectionView.register(ProfileContentEmptyCell.self, forCellWithReuseIdentifier: Constants.profileContentEmptyCellId)
        collectionView.register(ProfileContentCell.self, forCellWithReuseIdentifier: Constants.profileContentCellId)
    }
    
    private func infoViewModel(from pofile: Profile?) -> ProfileInfoContentViewModel? {
//        guard let profile = profileManager.profile else { return nil }
        
        let date = Calendar.current.date(byAdding: .year, value: -25, to: Date())
        return ProfileInfoContentViewModel(name: "Lucas Bailey",
                                           desciption: ("🔘" + " I do business in the club industry for 17 years.\n" + "🔘" + " I was the CCO of many international projects."),
                                           address: "Paris, France",
                                           dateOfBirth: date, 
                                           isVerified: true)
    }
    
    private func socialsModel(from profile: Profile?) -> ProfileSocialButtonContentViewModel? {
        return ProfileSocialButtonContentViewModel(socials: [
            .init(type: .facebook, url: URL(string: "https://www.instagram.com/ikorunny?igsh=MTVxZnVyZGVxM3lqcw%3D%3D&utm_source=qr")!),
            .init(type: .instagram, url: URL(string: "https://www.instagram.com/ikorunny?igsh=MTVxZnVyZGVxM3lqcw%3D%3D&utm_source=qr")!),
            .init(type: .x, url: URL(string: "https://www.instagram.com/ikorunny?igsh=MTVxZnVyZGVxM3lqcw%3D%3D&utm_source=qr")!)
        ]) { url in
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    private func toEditProfile() {
        ProfileRouter.shared.toEditProfile { [weak self] in
            guard let self else { return }
            self.collectionView?.reloadData()
            self.view?.setMakePostButton(visible: self.isProfileFilled)
        }
        profileManager.isProfileEdited = true
    }
    
    private func numberOfItems(for tab: ProfileTab) -> Int {
        switch tab {
        case .content:
            return 4
        case .events:
            return 0
        case .places:
            return 0
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
}


extension MyProfileVCViewModelImpl: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isProfileFilled ? 4 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case Constants.socialSectionIndex:
            return isProfileFilled ? 2 : 1
        case Constants.contentSegmentSectionIndex:
            return isProfileFilled ? 1 : 0
        case Constants.contentSectionIndex:
            let contentNumber = numberOfItems(for: contentType)
            return (contentNumber == 0 ? 1 : contentNumber)
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileHeaderId, for: indexPath) as! ProfileHeaderCell
            let profileHeaderViewModel = ProvileHeaderContentViewModel(
                profile: ProfileManager.shared.profile,
                onlineIdicator: .init(isHidden: false, status: .online)) { [weak self] in
                    self?.toEditProfile()
                } onShare: {
                    print("MyProfileVCViewModelImpl -> OnShare")
                }

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
                return cell
            }
        }
            
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.window?.bounds.width ?? .leastNormalMagnitude
        if indexPath.section == 0 {
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
        let width = collectionView.window?.bounds.width ?? .leastNormalMagnitude
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
}
