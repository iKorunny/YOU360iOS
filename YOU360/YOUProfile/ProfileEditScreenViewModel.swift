//
//  ProfileEditScreenViewModel.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/10/24.
//

import Foundation
import UIKit
import YOUProfileInterfaces
import YOUUtils
import YOUUIComponents

protocol ProfileEditScreenViewModel {
    func set(tableView: UITableView, controller: UIViewController)
}

private enum ProfileEditFieldsSection: Int {
    case names
    case aboutMe
    case more
    case social
    
    static func section(from index: Int) -> ProfileEditFieldsSection {
        switch index {
        case 2:
            return .names
        case 4:
            return .aboutMe
        case 6:
            return .more
        case 9:
            return .social
        default:
            fatalError("Bad ProfileEditFieldsSection")
        }
    }
}

final class ProfileEditScreenViewModelImpl: NSObject, ProfileEditScreenViewModel {
    private enum Constants {
        static let avatarsCellID = "ProfileEditAvatarsCell"
        static let imageButtonsCellID = "ProfileEditImagesButtonsCell"
        static let fieldsCellID = "ProfileEditFieldsCell"
        static let pushScreenLinesCellID = "ProfileEditPushScreenCell"
        static let headerFooterCellID = "ProfileEditHeaderFooterCell"
        
        static let fieldsPlaceholderTextSize: CGFloat = 14
        static let fieldsTextSize: CGFloat = 14
        
        enum fieldsIDs {
            static let nameField = "ProfileEditNameField"
            static let lastNameField = "ProfileEditLastNameField"
            static let aboutField = "ProfileEditAboutMeField"
            static let dateOfBirthField = "ProfileEditDateOfBirthField"
            static let cityField = "ProfileEditCity"
            static let phoneNumberField = "ProfileEditPhoneNumberField"
            static let paymentMethodField = "ProfileEditPaymentMethodField"
            static let instagramField = "ProfileEditInstagramField"
            static let facebookField = "ProfileEditFacebookField"
            static let twitterField = "ProfileEditTwitterField"
        }
        
        enum headerFooter {
            static let footerTextSize: CGFloat = 12
            static let headerTextSize: CGFloat = 14
        }
    }
    
    private var selectedAvatar: UIImage?
    private var selectedBanner: UIImage?
    
    private lazy var imagePicker: YOUImagePicker = {
       return YOUImagePicker(delegate: self)
    }()
    
    private lazy var fieldsViewModels: [ProfileEditFieldsContentViewModel] = [
        ProfileEditFieldsContentViewModel(fieldModels: [
            .init(
                identifier: Constants.fieldsIDs.nameField,
                placeholder: "ProfileEditNameFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: nil,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary),
            .init(
                identifier: Constants.fieldsIDs.lastNameField,
                placeholder: "ProfileEditLastNameFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: nil,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary)]),
        ProfileEditFieldsContentViewModel(fieldModels: [
            .init(
                identifier: Constants.fieldsIDs.aboutField,
                placeholder: "ProfileEditAboutMeFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: nil,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary)]),
        ProfileEditFieldsContentViewModel(fieldModels: [
            .init(
                identifier: Constants.fieldsIDs.dateOfBirthField,
                placeholder: "ProfileEditDateOfBirthFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: nil,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary),
            .init(
                identifier: Constants.fieldsIDs.cityField,
                placeholder: "ProfileEditCityPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: nil,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary)]),
        ProfileEditFieldsContentViewModel(fieldModels: [
            .init(
                identifier: Constants.fieldsIDs.instagramField,
                placeholder: "ProfileEditInstagramFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: nil,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary),
            .init(
                identifier: Constants.fieldsIDs.facebookField,
                placeholder: "ProfileEditFacebookFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: nil,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary),
            .init(
                identifier: Constants.fieldsIDs.twitterField,
                placeholder: "ProfileEditTwitterFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: nil,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary)])
    ]
    
    private lazy var pushScreenModel: ProfileEditPushScreenContentViewModel = {
        return .init(models: [
            ProfileEditPushScreenLineModel(identifier: Constants.fieldsIDs.phoneNumberField,
                                           placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                                           placeholderColor: ColorPallete.appGrey,
                                           placeholder: "ProfileEditPhoneNumberFieldPlaceholder".localised(),
                                           textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                                           textColor: ColorPallete.appBlackSecondary,
                                           action: {
                                               print("ProfileEditScreenViewModelImpl -> phoneNumber")
                                           }),
            ProfileEditPushScreenLineModel(identifier: Constants.fieldsIDs.paymentMethodField,
                                           placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                                           placeholderColor: ColorPallete.appGrey,
                                           placeholder: "ProfileEditPaymentMethodFieldPlaceholder".localised(),
                                           textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                                           textColor: ColorPallete.appBlackSecondary,
                                           action: {
                                               print("ProfileEditScreenViewModelImpl -> to paymentMethod")
                                           })
        ])
    }()
    
    private weak var table: UITableView?
    private weak var controller: UIViewController?
    
    let profileManager: ProfileManager
    
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    func set(tableView: UITableView, controller: UIViewController) {
        self.controller = controller
        self.table = tableView
        registerCells(for: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        table?.rowHeight = UITableView.automaticDimension
    }
    
    private func registerCells(for tableView: UITableView) {
        tableView.register(ProfileEditAvatarsCell.self, forCellReuseIdentifier: Constants.avatarsCellID)
        tableView.register(ProfileEditImagesButtonsCell.self, forCellReuseIdentifier: Constants.imageButtonsCellID)
        tableView.register(ProfileEditFieldsCell.self, forCellReuseIdentifier: Constants.fieldsCellID)
        tableView.register(ProfileEditPushScreenCell.self, forCellReuseIdentifier: Constants.pushScreenLinesCellID)
        tableView.register(ProfileEditHeaderFooterCell.self, forCellReuseIdentifier: Constants.headerFooterCellID)
    }
    
    private func fieldsModel(for section: ProfileEditFieldsSection) -> ProfileEditFieldsContentViewModel {
        return fieldsViewModels[section.rawValue]
    }
    
    private func deactivateInputFields() {
        
    }
    
    private func onChooseAvatar() {
        guard let vc = controller else { return }
        imagePicker.present(from: vc, type: .avatar)
    }
    
    private func onChooseBanner() {
        guard let vc = controller else { return }
        imagePicker.present(from: vc, type: .banner)
    }
}

extension ProfileEditScreenViewModelImpl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + fieldsViewModels.count + 1 + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.avatarsCellID, for: indexPath) as! ProfileEditAvatarsCell
            cell.apply(viewModel: ProfileEditHeaderContentViewModel(profile: profileManager.profile,
                                                                    selectedAvatar: selectedAvatar,
                                                                    selectedBanner: selectedBanner))
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.imageButtonsCellID, for: indexPath) as! ProfileEditImagesButtonsCell
            cell.apply(viewModel: ProfileEditImagesButtonsCellViewModel(onChooseAvatar: { [weak self] in
                self?.onChooseAvatar()
                
            }, onChooseBanner: { [weak self] in
                self?.onChooseBanner()
            }))
            return cell
        case 2, 4, 6, 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.fieldsCellID, for: indexPath) as! ProfileEditFieldsCell
            cell.apply(model: fieldsModel(for: .section(from: indexPath.row)))
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.pushScreenLinesCellID, for: indexPath) as! ProfileEditPushScreenCell
            cell.apply(model: pushScreenModel)
            return cell
        case 3, 5, 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.headerFooterCellID, for: indexPath) as! ProfileEditHeaderFooterCell
            if let model = headerFooterModel(for: indexPath.row) {
                cell.apply(model: model)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        deactivateInputFields()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func headerFooterModel(for index: Int) -> ProfileEditHeaderFooterContentViewModel? {
        switch index {
        case 3:
            return ProfileEditHeaderFooterContentViewModel(models: [
                .init(type: .footer,
                      text: "ProfileEditNamesFooter".localised(),
                      font: YOUFontsProvider.appRegularFont(with: Constants.headerFooter.footerTextSize),
                      color: ColorPallete.appGrey)
            ])
        case 5:
            return ProfileEditHeaderFooterContentViewModel(models: [
                .init(type: .footer,
                      text: "ProfileEditAboutMeFooter".localised(),
                      font: YOUFontsProvider.appRegularFont(with: Constants.headerFooter.footerTextSize),
                      color: ColorPallete.appGrey),
                .init(type: .header,
                      text: "ProfileEditMoreHeader".localised(),
                      font: YOUFontsProvider.appMediumFont(with: Constants.headerFooter.headerTextSize),
                      color: ColorPallete.appBlackSecondary)
            ])
        case 8:
            return ProfileEditHeaderFooterContentViewModel(models: [
                .init(type: .footer,
                      text: "ProfileEditPhoneNPaymentFooter".localised(),
                      font: YOUFontsProvider.appRegularFont(with: Constants.headerFooter.footerTextSize),
                      color: ColorPallete.appGrey),
                .init(type: .header,
                      text: "ProfileEditSocialHeader".localised(),
                      font: YOUFontsProvider.appMediumFont(with: Constants.headerFooter.headerTextSize),
                      color: ColorPallete.appBlackSecondary)
            ])
        default: return nil
        }
    }
}

extension ProfileEditScreenViewModelImpl: YOUImagePickerDelegate {
    func didPick(image: UIImage?, type: YOUImagePickerType) {
        switch type {
        case .avatar:
            selectedAvatar = image
            updateAvatars()
        case .banner:
            selectedBanner = image
            updateAvatars()
        default: return
        }
    }
    
    private func updateAvatars() {
        table?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}
