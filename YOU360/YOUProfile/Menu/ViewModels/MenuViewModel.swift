//
//  MenuViewModel.swift
//  YOUProfile
//
//  Created by Andrey Matoshko on 10.04.24.
//

import UIKit
import YOUUIComponents
import YOUUtils
import YOUAuthorization
import YOUNetworking

protocol MenuViewModel {
    var view: MenuView? { get set }
    
    func onViewDidLoad()
    func onWillDissapear()
    func set(tableView: UITableView)
}

struct Section {
    let name: String
    var numberOfRows: Int { items.count }
    let items: [MenuItem]
}

final class MenuViewModelImpl: NSObject, MenuViewModel {
    private enum Constants {
        static let menuProfileCellID = "menuProfileCellID"
        static let menuCellID = "MenuCell"
        static let dropDownCellId = "MenuDropDownCell"
        static let fieldsCellIndex: Int = 1
        static let heightOfRow: CGFloat = 72
        static let profileHeightOfRow: CGFloat = 72
        static let sectionTitleOffset: CGFloat = 16
        
        static let sectionTitleColor = ColorPallete.appGrey
        static let sectionSeparatorColor = ColorPallete.appWeakPink
        static let textFont = YOUFontsProvider.appSemiBoldFont(with: 14)
    }
    
    let onClose: (() -> Void)
    
    private lazy var networkService = ProfileNetworkService.makeService()
    private lazy var loaderManager: LoaderManager = {
        return LoaderManager()
    }()
    
    var tableView: UITableView?
    var view: MenuView?
    private var profile: UserInfoResponse?
    private var avatarImage: UIImage?
    
    var heightForRow: CGFloat {
        return Constants.heightOfRow
    }
    
    private lazy var sections: [Section] = {
        getSections()
    }()
    
    init(onClose: @escaping (() -> Void)) {
        self.onClose = onClose
    }
    
    func set(tableView: UITableView) {
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceHorizontal = false
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(MenuCell.self, forCellReuseIdentifier: Constants.menuCellID)
        tableView.register(MenuCell.self, forCellReuseIdentifier: Constants.menuProfileCellID)
        tableView.register(MenuDropDownCell.self, forCellReuseIdentifier: Constants.dropDownCellId)
    }
    
    func onViewDidLoad() {
        loadProfile()
    }
    
    func onWillDissapear() {
        onClose()
    }
    
    func cellForRow(with index: IndexPath, for table: UITableView) -> UITableViewCell {
        var cell: UITableViewCell?
        let item = itemForIndex(index)
        
        if let regularItem = item as? MenuItemRegular {
            if regularItem.type == .profile {
                let profileCell = table.dequeueReusableCell(withIdentifier: Constants.menuProfileCellID, for: index) as? MenuCell
                let menuViewModel = MenuContentViewModelImpl(item: regularItem, reloadAction: reload)
                profileCell?.apply(viewModel: menuViewModel)
                cell = profileCell
            } else {
                let regularCell = table.dequeueReusableCell(withIdentifier: Constants.menuCellID, for: index) as? MenuCell
                let menuViewModel = MenuContentViewModelImpl(item: regularItem, reloadAction: reload)
                regularCell?.apply(viewModel: menuViewModel)
                cell = regularCell
            }
        }
        else if let dropDown = item as? MenuDropDownViewData {
            let dropDownCell = table.dequeueReusableCell(withIdentifier: Constants.dropDownCellId, for: index) as? MenuDropDownCell
            dropDownCell?.apply(viewModel: dropDown)
            cell = dropDownCell
        }
        
        return cell ?? UITableViewCell()
    }
    
    private func itemForIndex(_ index: IndexPath) -> MenuItem {
        sections[index.section].items[index.row]
    }
    
    private func reloadProfile() {
        sections = getSections()
        tableView?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    private func reload() {
        sections = getSections()
        view?.reload()
    }
    
    private func logoutAction() {
        ProfileManager.shared.deleteProfile()
        AuthorizationService.shared.onLogout()
    }
    
    private func loadProfile() {
        if let view = (view as? UIViewController)?.tabBarController {
            loaderManager.addFullscreenLoader(for: view)
        }
        
        profile = ProfileManager.shared.profile
        
        if let imagePath = profile?.avatar?.contentUrl {
            networkService.makeDownloadImageGetRequest(imagePath: imagePath) { [weak self] avatar in
                self?.avatarImage = avatar
                self?.loaderManager.removeFullscreenLoader()
                self?.reloadProfile()
            }
        }
        else {
            loaderManager.removeFullscreenLoader()
        }
    }
    
    private func createDistanceItem() -> MenuDropDownViewData {
        let item = MenuDropDownViewData(
            title: "DistanceTitle".localised(),
            iconImage: MenuItemIcons.distance,
            description: "MenuDistanceDescription".localised(),
            selectedItemId: "5 miles"
        )
        item.options = [
            .init(itemId: "5 miles", title: "5 miles".localised()),
            .init(itemId: "10 miles", title: "10 miles".localised()),
            .init(itemId: "15 miles", title: "15 miles".localised()),
        ]
        return item
    }
    
    private func getSections() -> [Section] {
        [
            Section(name: "", items: [
                getProfileItem(),
                MenuItemRegular(title: "ProfileSettingsTitle".localised(), type: .standart, icon: MenuItemIcons.profile),
                MenuItemRegular(title: "HistorOfReservationsTitle".localised(), type: .standart, icon: MenuItemIcons.history),
                MenuItemRegular(title: "PaymentMethodsTitle".localised(), type: .standart, icon: MenuItemIcons.payment),
                createDistanceItem()
            ]),
            Section(name: "SettingsAndPreferencesTitle".localised(), items: [
                MenuItemRegular(title: "NotificationsTitle".localised(), type: .standart, icon: MenuItemIcons.notifications),
                MenuItemRegular(title: "DarkModeTitle".localised(), type: .switchKey, icon: MenuItemIcons.moon),
            ]),
            Section(name: "SupportTitle".localised(), items: [
                MenuItemRegular(title: "HelpCenterTitle".localised(), type: .standart, icon: MenuItemIcons.help),
                MenuItemRegular(title: "ReportBugTitle".localised(), type: .standart, icon: MenuItemIcons.report),
                MenuItemRegular(title: "LogOutTitle".localised(), type: .logOut, icon: MenuItemIcons.logOut, action: {
                    AuthorizationAPIService.shared.requestLogout { success, errors in
                        DispatchQueue.main.async { [weak self] in
                            self?.loaderManager.removeFullscreenLoader() { [weak self] _ in
                                if success {
                                    self?.logoutAction()
                                } else {
                                    self?.handleErrors(errors)
                                }
                            }
                        }
                    }
                })
            ])
        ]
    }
    
    private func getProfileItem() -> MenuItem {
        if let profile = profile {
            var profileItem = MenuItemRegular(title: profile.displayName, type: .profile, subTitle: profile.email, icon: avatarImage ?? UIImage(named: "ProfileAvatarPlaceholder"))
            
            if let avatar = avatarImage {
                profileItem.icon = avatar
            }
            
            return profileItem
        } else {
            handleProfileError()
            let emptyProfileItem = MenuItemRegular(title: "", type: .profile, icon: UIImage(named: "ProfileAvatarPlaceholder"))
            return emptyProfileItem
        }
    }
    
    private func handleErrors(_ errors: [AuthorizationAPIError]) {
        guard let view = view as? UIViewController else { return }
        if errors.contains(where: { $0.isNoInternet }) {
            AlertsPresenter.presentNoInternet(from: view)
        }
        else {
            AlertsPresenter.presentSomethingWentWrongAlert(from: view)
        }
    }
    
    private func handleProfileError() { }

}

// MARK: UITableView

extension MenuViewModelImpl: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellForRow(with: indexPath, for: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].name
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = itemForIndex(indexPath)
        
        if let regularItem = item as? MenuItemRegular {
            if regularItem.type == .profile {
                return Constants.profileHeightOfRow
            } else {
                return heightForRow
            }
        }
        else if let dropDown = item as? MenuDropDownViewData {
            if dropDown.expanded {
                return 320
            }
            else {
                return heightForRow
            }
        }
        else {
            return heightForRow
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dropDownCell = tableView.cellForRow(at: indexPath) as? MenuDropDownCell,
           let viewData = dropDownCell.viewData {
            
            dropDownCell.setExpanded(!viewData.expanded, animated: true)
            UIView.animate(withDuration: 0.3) {
                self.tableView?.performBatchUpdates(nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        let separatorView = UIView(frame: CGRect(origin: CGPoint(x: Constants.sectionTitleOffset, y: -Constants.sectionTitleOffset), size: CGSize(width: header.frame.width - Constants.sectionTitleOffset * 2, height: 1)))
        separatorView.backgroundColor = Constants.sectionSeparatorColor
        header.contentView.addSubview(separatorView)
        header.textLabel?.textColor = Constants.sectionTitleColor
        header.textLabel?.font = Constants.textFont
        header.textLabel?.frame = header.bounds.offsetBy(dx: Constants.sectionTitleOffset, dy: 0)
        header.textLabel?.textAlignment = .left
    }
}
