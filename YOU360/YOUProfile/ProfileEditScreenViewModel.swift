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

protocol EditProfileField {
    func apply()
}

protocol ProfileEditScreenView {
    func close()
}

protocol ProfileEditScreenViewModel {
    func set(tableView: UITableView,
             controller: UIViewController & ProfileEditScreenView,
             tableViewBottomConstraint: NSLayoutConstraint)
    func deactivateInputFields()
    func onWillDissapear()
    func onSave()
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
        
        static let inputViewShowHideAnimationDuration: CGFloat = 0.3
    }
    
    private var selectedAvatar: UIImage?
    private var selectedBanner: UIImage?
    private var didSelectAvatar = false
    private var didSelectBanner = false
    private var selectedDateOfBirth: Date? {
        didSet {
            let moreModel = fieldsModel(for: .more)
            moreModel.fieldModels.first { $0.type == .date }?.text = Formatters.formateDayMonthYear(date: selectedDateOfBirth)
        }
    }
    
    private lazy var loaderManager: LoaderManager = {
        return LoaderManager()
    }()
    
    private lazy var imagePicker: YOUImagePicker = {
       return YOUNativeImagePicker(delegate: self)
    }()
    
    private lazy var datePicker: YOUDatePicker = {
        let picker = YOUNativeDatePicker()
        picker.dateDidChange = { [weak self] date in
            self?.selectedDateOfBirth = date
            self?.updateMore()
        }
        
        picker.onWillFinishEditing = { [weak self] in
            self?.onHideInputView()
        }
        
        return picker
    }()
    
    private var tableInputScroller: TableViewInputScrollerService?
    
    private lazy var fieldsViewModels: [ProfileEditFieldsContentViewModel] = [
        ProfileEditFieldsContentViewModel(fieldModels: [
            .init(
                identifier: Constants.fieldsIDs.nameField,
                placeholder: "ProfileEditNameFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: profileManager.profile?.name,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary, 
                actionsDelegate: self),
            .init(
                identifier: Constants.fieldsIDs.lastNameField,
                placeholder: "ProfileEditLastNameFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: profileManager.profile?.surname,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary,
                actionsDelegate: self)]),
        ProfileEditFieldsContentViewModel(fieldModels: [
            .init(
                identifier: Constants.fieldsIDs.aboutField,
                placeholder: "ProfileEditAboutMeFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: profileManager.profile?.aboutMe,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary, 
                actionsDelegate: self)]),
        ProfileEditFieldsContentViewModel(fieldModels: [
            .init(
                identifier: Constants.fieldsIDs.dateOfBirthField,
                type: .date,
                placeholder: "ProfileEditDateOfBirthFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: Formatters.formateDayMonthYear(date: selectedDateOfBirth ?? profileManager.profile?.birthDate),
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary, 
                actionsDelegate: self),
            .init(
                identifier: Constants.fieldsIDs.cityField,
                placeholder: "ProfileEditCityPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: profileManager.profile?.city,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary, 
                actionsDelegate: self)]),
        ProfileEditFieldsContentViewModel(fieldModels: [
            .init(
                identifier: Constants.fieldsIDs.instagramField,
                placeholder: "ProfileEditInstagramFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: profileManager.profile?.instagram,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary,
                actionsDelegate: self),
            .init(
                identifier: Constants.fieldsIDs.facebookField,
                placeholder: "ProfileEditFacebookFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: profileManager.profile?.facebook,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary, 
                actionsDelegate: self),
            .init(
                identifier: Constants.fieldsIDs.twitterField,
                placeholder: "ProfileEditTwitterFieldPlaceholder".localised(),
                placeholderFont: YOUFontsProvider.appMediumFont(with: Constants.fieldsPlaceholderTextSize),
                placeholderColor: ColorPallete.appGrey,
                text: profileManager.profile?.twitter,
                textFont: YOUFontsProvider.appSemiBoldFont(with: Constants.fieldsTextSize),
                textColor: ColorPallete.appBlackSecondary, 
                actionsDelegate: self)])
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
    private weak var controller: (UIViewController & ProfileEditScreenView)?
    private weak var tableViewBottomConstraint: NSLayoutConstraint?
    
    private var saved: Bool = false
    
    let profileManager: ProfileManager
    let onClose: ((Bool, Bool,UIImage?, UIImage?, Bool) -> Void)
    
    init(profileManager: ProfileManager, onClose: @escaping ((Bool, Bool, UIImage?, UIImage?, Bool) -> Void)) {
        self.profileManager = profileManager
        self.onClose = onClose
        super.init()
    }
    
    func set(tableView: UITableView,
             controller: UIViewController & ProfileEditScreenView,
             tableViewBottomConstraint: NSLayoutConstraint) {
        self.controller = controller
        self.table = tableView
        self.tableViewBottomConstraint = tableViewBottomConstraint
        registerCells(for: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        table?.rowHeight = UITableView.automaticDimension
        
        tableInputScroller = TableViewInputScrollerService(mainView: controller.view,
                                                           tableView: tableView,
                                                           bottomConstraint: tableViewBottomConstraint,
                                                           delegate: self)
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
    
    func deactivateInputFields() {
        datePicker.dismiss()
        fieldsViewModels.forEach { $0.resignActive() }
    }
    
    func onSave() {
        deactivateInputFields()
        saveInputs()
        guard let profile = profileManager.profile else { return }
        if let controller = controller {
            loaderManager.addFullscreenLoader(for: controller)
        }
        
        ProfileNetworkService().makeUpdateProfileRequest(
            id: profile.id,
            email: profile.email,
            username: profile.userName ?? "",
            name: nameToSave,
            surname: surnameToSave,
            aboutMe: aboutMeToSave,
            dateOfBirth: selectedDateOfBirth ?? profile.birthDate,
            city: cityToSave,
            paymentMethod: paymentMethodToSave,
            instagram: instagramToSave,
            facebook: facebookToSave,
            twitter: twitterToSave,
            avatar: selectedAvatar,
            isAvatarUpdated: didSelectAvatar,
            banner: selectedBanner,
            isBannerUpdated: didSelectBanner) { [weak self] success, profile, localError in
                self?.saved = success
                self?.loaderManager.removeFullscreenLoader { [weak self] removed in
                    guard removed, success else { return }
                    self?.controller?.close()
                }
                
                if success, let profile {
                    ProfileManager.shared.set(profile: profile)
                }
                else {
                    if let vc = self?.controller {
                        if localError == .noInternet {
                            AlertsPresenter.presentNoInternet(from: vc)
                        }
                        else {
                            AlertsPresenter.presentSomethingWentWrongAlert(from: vc)
                        }
                    }
                }
            }
    }
    
    private func saveInputs() {
        fieldsViewModels.forEach { $0.apply() }
        pushScreenModel.apply()
    }
    
    func onWillDissapear() {
        onClose(didSelectAvatar, didSelectBanner, selectedAvatar, selectedBanner, saved)
    }
    
    private func onChooseAvatar() {
        guard let vc = controller else { return }
        imagePicker.present(from: vc, type: .avatar)
    }
    
    private func onChooseBanner() {
        guard let vc = controller else { return }
        imagePicker.present(from: vc, type: .banner)
    }
    
    private func onHideInputView() {
        tableViewBottomConstraint?.constant = 0
        UIView.animate(withDuration: Constants.inputViewShowHideAnimationDuration) { [weak self] in
            self?.controller?.view.layoutIfNeeded()
        }
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
                                                                    selectedAvatar: selectedAvatar ?? profileManager.avatar,
                                                                    selectedBanner: selectedBanner ?? profileManager.banner))
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
            let model = fieldsModel(for: .section(from: indexPath.row))
            model.indexPath = indexPath
            cell.apply(model: model)
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
        guard scrollView.isDragging || scrollView.isTracking else { return }
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
            didSelectAvatar = true
            updateAvatars()
        case .banner:
            selectedBanner = image
            didSelectBanner = true
            updateAvatars()
        default: return
        }
    }
    
    private func updateAvatars() {
        table?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    private func updateMore() {
        table?.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .none)
    }
}

extension ProfileEditScreenViewModelImpl: ProfileEditFieldActionsDelegate {
    func onShouldEndEditing(for type: ProfileEditFieldModelType) {
        
    }
    
    func willShowPicker(for type: ProfileEditFieldModelType) -> Bool {
        switch type {
        case .date: return true
        case .keyboard: return false
        }
    }
    
    func onShouldBeginEditing(for type: ProfileEditFieldModelType) {
        switch type {
        case .keyboard: return
        case .date:
            guard let controller else { return }
            datePicker.present(from: controller, with: selectedDateOfBirth ?? profileManager.profile?.birthDate)
            tableInputScroller?.onShowInputView(with: datePicker.pickerHeight, type: .date)
        }
    }
}

extension ProfileEditScreenViewModelImpl {
    private var fieldModels: [ProfileEditFieldModel] {
        var result: [ProfileEditFieldModel] = []
        fieldsViewModels.forEach { result.append(contentsOf: $0.fieldModels) }
        return result
    }
    var nameToSave: String? {
        return fieldModels.first(where: { $0.identifier == Constants.fieldsIDs.nameField })?.text
    }
    var surnameToSave: String? {
        return fieldModels.first(where: { $0.identifier == Constants.fieldsIDs.lastNameField })?.text
    }
    var aboutMeToSave: String? {
        return fieldModels.first(where: { $0.identifier == Constants.fieldsIDs.aboutField })?.text
    }
    var cityToSave: String? {
        return fieldModels.first(where: { $0.identifier == Constants.fieldsIDs.cityField })?.text
    }
    var phoneNumberToSave: String? {
        return pushScreenModel.models.first(where: { $0.identifier == Constants.fieldsIDs.phoneNumberField })?.text
    }
    var paymentMethodToSave: String? {
        return pushScreenModel.models.first(where: { $0.identifier == Constants.fieldsIDs.paymentMethodField })?.text
    }
    var instagramToSave: String? {
        return fieldModels.first(where: { $0.identifier == Constants.fieldsIDs.instagramField })?.text
    }
    var facebookToSave: String? {
        return fieldModels.first(where: { $0.identifier == Constants.fieldsIDs.facebookField })?.text
    }
    var twitterToSave: String? {
        return fieldModels.first(where: { $0.identifier == Constants.fieldsIDs.twitterField })?.text
    }
}

extension ProfileEditScreenViewModelImpl: TableViewInputScrollerDelegate {
    func indexPath(for type: TableViewInputScrollerType) -> IndexPath? {
        switch type {
        case .date:
            return fieldsViewModels.first(where: { $0.fieldModels.contains(where: { $0.type == .date }) })?.indexPath
        case .keyboard:
            return fieldsViewModels.first(where: { $0.isFirstResponder })?.indexPath
        }
    }
}
