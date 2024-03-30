//
//  ProfileContentSegmentContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/28/24.
//

import UIKit
import YOUUtils

final class ProfileContentSegmentContentViewModel {
    let tabs: [ProfileTab]
    let onSelectTab: ((ProfileTab) -> Void)
    var selectedTab: ProfileTab
    
    init(tabs: [ProfileTab], 
         selectedTab: ProfileTab,
         onSelectTab: @escaping (ProfileTab) -> Void) {
        self.tabs = tabs
        self.onSelectTab = onSelectTab
        self.selectedTab = selectedTab
    }
}

final class ProfileContentSegmentContentView: UIView {
    
    private enum Constants {
        static let horizontalOffset: CGFloat = 20
        static let segmentHeight: CGFloat = 40
        static let segmentCornerRadius: CGFloat = 12
    }

    private var viewModel: ProfileContentSegmentContentViewModel?
    
    private lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.masksToBounds = true
        segment.layer.cornerRadius = Constants.segmentCornerRadius
        
        segment.backgroundColor = ColorPallete.appWhite
        segment.selectedSegmentTintColor = ColorPallete.appPink
        
        segment.addTarget(self, action: #selector(onSelectSegment), for: .valueChanged)
        
        return segment
    }()

    func apply(viewModel: ProfileContentSegmentContentViewModel) {
        guard segment.numberOfSegments == 0 else { return }
        subviews.forEach { $0.removeFromSuperview() }
        
        self.viewModel = viewModel
        
        let items = viewModel.tabs.compactMap { (viewModel.selectedTab == $0 ? $0.selectedIcon : $0.icon)?.embed(with: $0.title ?? "", color: viewModel.selectedTab == $0 ? ColorPallete.appWhite : ColorPallete.appGrey).withRenderingMode(.alwaysOriginal) }
        items.reversed().forEach { segment.insertSegment(with: $0, at: 0, animated: false) }

        addSubview(segment)
        segment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalOffset).isActive = true
        segment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalOffset).isActive = true
        segment.topAnchor.constraint(equalTo: topAnchor).isActive = true
        segment.heightAnchor.constraint(equalToConstant: Constants.segmentHeight).isActive = true
        
        if let selectedIndex = viewModel.tabs.firstIndex(of: viewModel.selectedTab) {
            segment.selectedSegmentIndex = selectedIndex
        }
    }
    
    private func resetItemImages() {
        guard let viewModel else { return }
        for i in 0..<viewModel.tabs.count {
            let tab = viewModel.tabs[i]
            segment.setImage((viewModel.selectedTab == tab ? tab.selectedIcon : tab.icon)?
                .embed(with: tab.title ?? "",
                                             color: viewModel.selectedTab == tab ? ColorPallete.appWhite : ColorPallete.appGrey)
                .withRenderingMode(.alwaysOriginal),
                             forSegmentAt: i)
        }
    }

    @objc private func onSelectSegment() {
        guard let viewModel else { return }
        let selectedIndex = segment.selectedSegmentIndex
        viewModel.selectedTab = viewModel.tabs[selectedIndex]
        resetItemImages()
        viewModel.onSelectTab(viewModel.selectedTab)
    }
}
