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

protocol ProfileEditScreenViewModel {
    func set(tableView: UITableView)
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
        case 3:
            return .aboutMe
        case 4:
            return .more
        case 6:
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
    }
    
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
    
    let profileManager: ProfileManager
    
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    func set(tableView: UITableView) {
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
    }
    
    private func fieldsModel(for section: ProfileEditFieldsSection) -> ProfileEditFieldsContentViewModel {
        return fieldsViewModels[section.rawValue]
    }
    
    private func deactivateInputFields() {
        
    }
}

extension ProfileEditScreenViewModelImpl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + fieldsViewModels.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.avatarsCellID, for: indexPath) as! ProfileEditAvatarsCell
            cell.apply(viewModel: ProfileEditHeaderContentViewModel(profile: profileManager.profile))
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.imageButtonsCellID, for: indexPath) as! ProfileEditImagesButtonsCell
            cell.apply(viewModel: ProfileEditImagesButtonsCellViewModel(onChooseAvatar: {
                print("ProfileEditScreenViewModelImpl -> onChooseAvatar")
            }, onChooseBanner: {
                print("ProfileEditScreenViewModelImpl -> onChooseBanner")
            }))
            return cell
        case 2, 3, 4, 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.fieldsCellID, for: indexPath) as! ProfileEditFieldsCell
            cell.apply(model: fieldsModel(for: .section(from: indexPath.row)))
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.pushScreenLinesCellID, for: indexPath) as! ProfileEditPushScreenCell
            cell.apply(model: pushScreenModel)
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
}
