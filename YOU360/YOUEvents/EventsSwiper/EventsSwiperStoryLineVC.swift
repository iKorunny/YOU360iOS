//
//  EventsSwiperStoryLineVC.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/21/24.
//

import UIKit
import YOUUtils

final class EventsSwiperStoryLineVC: UIViewController {
    private enum Constants {
        static let innerItemSpacing: CGFloat = 5
        static let stackViewInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
        static let itemViewCornerRadius: CGFloat = 1.5
        static let itemNotSeenAlpha: CGFloat = 0.2
        static let itemSeenAlpha: CGFloat = 1.0
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.innerItemSpacing
        stack.distribution = .fillEqually
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorPallete.appWhiteSecondary
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.stackViewInsets.top).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackViewInsets.left).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.stackViewInsets.right).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.stackViewInsets.bottom).isActive = true
    }
    
    func redraw(with itemsNumber: Int) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
        }
        
        for _ in 0..<itemsNumber {
            stackView.addArrangedSubview(createItemView())
        }
    }
    
    func set(activeIndex: Int) {
        let arrangesSubviews = stackView.arrangedSubviews
        for i in 0 ..< arrangesSubviews.count {
            arrangesSubviews[i].alpha = i <= activeIndex ? Constants.itemSeenAlpha : Constants.itemNotSeenAlpha
        }
    }
    
    private func createItemView() -> UIView {
        let view = UIView()
        view.backgroundColor = ColorPallete.appPink
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Constants.itemViewCornerRadius
        view.alpha = Constants.itemNotSeenAlpha
        return view
    }
}
