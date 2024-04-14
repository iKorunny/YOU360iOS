//
//  MenuViewModel.swift
//  YOUProfile
//
//  Created by Andrey Matoshko on 10.04.24.
//

import UIKit
import YOUUIComponents
import YOUUtils
import YOUProfileInterfaces
import YOUAuthorization

protocol MenuViewModel {
    var tableView: UITableView? { get set }
    var viewController: UIViewController? { get set }
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
        static let menuCellID = "MenuCell"
        static let menuProfileCellID = "MenuProfileCell"
        static let fieldsCellIndex: Int = 1
        static let heightOfRow: CGFloat = 72
        static let profileHeightOfRow: CGFloat = 72
        static let sectionTitleOffset: CGFloat = 16
        
        static let sectionTitleColor = ColorPallete.appGrey
        static let sectionSeparatorColor = ColorPallete.appWeakPink
        static let textFont = YOUFontsProvider.appSemiBoldFont(with: 14)
    }
    
    let onClose: (() -> Void)
    private lazy var loaderManager: LoaderManager = {
        return LoaderManager()
    }()
    
    var tableView: UITableView?
    var viewController: UIViewController?
    
    var heightForRow: CGFloat {
        return Constants.heightOfRow
    }
    
    private let sections: [Section] = [
        Section(name: "", items: [
            MenuItem(title: "Lucas Bailey", type: .profile, subTitle: "example@gmail.com", icon: MenuItem.Icons.mock),
            MenuItem(title: "Profile settings", type: .standart, icon: MenuItem.Icons.profile),
            MenuItem(title: "History of Reservations", type: .standart, icon: MenuItem.Icons.history),
            MenuItem(title: "Payment methods", type: .standart, icon: MenuItem.Icons.payment),
            MenuItem(title: "Distance", type: .standart, icon: MenuItem.Icons.distance),
        ]
               ),
        Section(name: "Settings & Preferences", items: [
            MenuItem(title: "Notifications", type: .standart, icon: MenuItem.Icons.notifications),
            MenuItem(title: "Dark Mode", type: .switchKey, icon: MenuItem.Icons.moon),
        ]
               ),
        Section(name: "Support", items: [
            MenuItem(title: "Help center", type: .standart, icon: MenuItem.Icons.help),
            MenuItem(title: "Report a bug", type: .standart, icon: MenuItem.Icons.report),
            MenuItem(title: "Log out", type: .logOut, icon: MenuItem.Icons.logOut, action: {
                print("LOGOUT")
                AuthorizationAPIService.shared.requestLogout { success, erros in
                    DispatchQueue.main.async {
                        ProfileRouter.shared.toLogin {
                            ProfileManager.shared.deleteProfile()
                        }
                    }
                }
            })
        ]
               )
    ]
    
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
        
        tableView.register(MenuProfileCell.self, forCellReuseIdentifier: Constants.menuProfileCellID)
        tableView.register(MenuCell.self, forCellReuseIdentifier: Constants.menuCellID)
    }
    
    func onWillDissapear() {
        onClose()
    }
    
    func cellForRow(with index: IndexPath, for table: UITableView) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: Constants.menuCellID, for: index) as? MenuCell else { return UITableViewCell() }
        let menuViewModel = MenuContentViewModelImpl(item: itemForIndex(index), reloadAction: reloadAction)
        
        cell.apply(viewModel: menuViewModel)
        return cell
    }
    
    private func itemForIndex(_ index: IndexPath) -> MenuItem {
        sections[index.section].items[index.row]
    }
    
    private func reloadAction() {
        tableView?.reloadData()
    }

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
        if itemForIndex(indexPath).type == .profile {
            return Constants.profileHeightOfRow
        } else {
            return heightForRow
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
