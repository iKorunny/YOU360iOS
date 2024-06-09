//
//  MenuDropDownCell.swift
//  YOUProfile
//
//  Created by Andrei Tamila on 6/1/24.
//

import UIKit
import YOUUtils

final class MenuDropDownViewData: MenuItem {
    struct Item {
        let itemId: String
        let title: String
        var selected: Bool = false
    }
    
    let title: String
    let iconImage: UIImage?
    let description: String?
    var selectedItemId: String?
    var expanded: Bool = false
    var options: [Item] = []
    
    init(title: String, iconImage: UIImage?, description: String? = nil, selectedItemId: String? = nil) {
        self.title = title
        self.iconImage = iconImage
        self.description = description
        self.selectedItemId = selectedItemId
    }
}

public protocol ItemViewDelegate: AnyObject {
    func didTappedItem(id: String)
}

final class MenuDropDownCell: UITableViewCell {
    
    private class ItemView: UIView {
        var viewData: MenuDropDownViewData.Item?
        weak var delegate: ItemViewDelegate?
        
        private lazy var textLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.adjustsFontSizeToFitWidth = true
            label.font = Constants.textFont
            label.textColor = Constants.mainTextColor
            return label
        }()
        
        private lazy var checkView: UIImageView = {
            let imageView = UIImageView(image: .init(named: "Tick"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            imageView.setContentHuggingPriority(.required, for: .horizontal)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        private var divider = MenuDropDownCell.createDivider()
        private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemTapped))
        
        init() {
            super.init(frame: CGRect.zero)
            setup()
            self.addGestureRecognizer(tapRecognizer)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
            addSubview(textLabel)
            addSubview(checkView)
            addSubview(divider)
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalToConstant: 56),
                textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                checkView.centerYAnchor.constraint(equalTo: centerYAnchor),
                checkView.trailingAnchor.constraint(equalTo: trailingAnchor),
                checkView.widthAnchor.constraint(equalToConstant: 24),
                checkView.heightAnchor.constraint(equalToConstant: 24),
                divider.leadingAnchor.constraint(equalTo: leadingAnchor),
                divider.trailingAnchor.constraint(equalTo: trailingAnchor),
                divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
        
        func setSelected(_ selected: Bool) {
            checkView.isHidden = !selected
        }
        
        func apply(viewData: MenuDropDownViewData.Item) {
            self.viewData = viewData
            textLabel.text = viewData.itemId
        }
        
        @objc func itemTapped() {
            print("tapped item with id \(String(describing: viewData?.itemId))")
            guard let viewData else { return }
            
            delegate?.didTappedItem(id: viewData.itemId)
        }
    }
    
    private enum Constants {
        static let leftIconHeight: CGFloat = 24
        static let leftIconWidth: CGFloat = 24
        
        static let rightIconWidth: CGFloat = 24
        
        static let textLeadingOffset: CGFloat = 8
        static let textHeight: CGFloat = 19
        static let textFont = YOUFontsProvider.appSemiBoldFont(with: 14)
        static let mainTextColor = ColorPallete.appBlackSecondary
        static let subTextColor = ColorPallete.appGrey
        
        static let margins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        static let padding = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
    
    var viewData: MenuDropDownViewData?
    
    private static func createDivider() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.backgroundColor = ColorPallete.appWeakPink
        
        return view
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    private let headView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let optionsView: UIView = {
        let view = UIControl()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var leftIconView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "CellOpenScreenIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.contentMode = .center
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.leftIconWidth),
            imageView.heightAnchor.constraint(equalToConstant: Constants.rightIconWidth)
        ])
        return imageView
    }()
    
    private lazy var arrowView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "dropdown_arrow"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.adjustsFontSizeToFitWidth = true
        label.font = Constants.textFont
        label.textColor = Constants.mainTextColor
        return label
    }()
    
    private lazy var selectedOptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textAlignment = .right
        label.font = Constants.textFont
        label.textColor = Constants.subTextColor
        return label
    }()
    
    private lazy var optionsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.font = Constants.textFont
        label.textColor = Constants.subTextColor
        return label
    }()
    
    private lazy var optionsStackContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private lazy var topDivider: UIView = Self.createDivider()
    
    private var optionViews: [ItemView] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupLayout()
        setExpanded(false, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        contentView.addSubview(containerView)
        
        containerView.addSubview(headView)
        headView.addSubview(leftIconView)
        headView.addSubview(mainTextLabel)
        headView.addSubview(selectedOptionLabel)
        headView.addSubview(arrowView)

        containerView.addSubview(optionsView)
        optionsView.addSubview(optionsDescriptionLabel)
        optionsView.addSubview(topDivider)
        optionsView.addSubview(optionsStackContainer)
        optionsStackContainer.addSubview(optionsStackView)
        
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        
        leftIconView.contentMode = .scaleAspectFit
    }
    
    private var contentDependentConstraints: [NSLayoutConstraint] = []
    private var expandDependentConstraints: [NSLayoutConstraint] = []
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.margins.top),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.margins.left),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.margins.right),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.margins.bottom),
            
            headView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headView.heightAnchor.constraint(equalToConstant: 60),
            
            optionsView.topAnchor.constraint(equalTo: headView.bottomAnchor),
            optionsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            optionsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            leftIconView.centerYAnchor.constraint(equalTo: headView.centerYAnchor),
            leftIconView.leadingAnchor.constraint(equalTo: headView.leadingAnchor, constant: Constants.padding.left),
            leftIconView.widthAnchor.constraint(equalToConstant: Constants.leftIconWidth),
            leftIconView.heightAnchor.constraint(equalToConstant: Constants.leftIconHeight),
            
            mainTextLabel.centerYAnchor.constraint(equalTo: headView.centerYAnchor),
            mainTextLabel.leadingAnchor.constraint(equalTo: leftIconView.trailingAnchor, constant: Constants.textLeadingOffset),
            
            arrowView.centerYAnchor.constraint(equalTo: headView.centerYAnchor),
            arrowView.trailingAnchor.constraint(equalTo: headView.trailingAnchor, constant: -Constants.padding.right),
            arrowView.heightAnchor.constraint(equalToConstant: 24),
            arrowView.widthAnchor.constraint(equalToConstant: 24),
            
            selectedOptionLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -12),
            selectedOptionLabel.centerYAnchor.constraint(equalTo: headView.centerYAnchor),
            
            optionsDescriptionLabel.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: Constants.padding.top),
            optionsDescriptionLabel.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor, constant: Constants.padding.left),
            optionsDescriptionLabel.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor, constant: -Constants.padding.right),
            
            topDivider.topAnchor.constraint(equalTo: optionsDescriptionLabel.bottomAnchor, constant: Constants.padding.top),
            topDivider.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor, constant: Constants.padding.left),
            topDivider.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor, constant: -Constants.padding.right),
            
            optionsStackContainer.topAnchor.constraint(equalTo: topDivider.bottomAnchor),
            optionsStackContainer.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor, constant: Constants.padding.left),
            optionsStackContainer.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor, constant: -Constants.padding.right),
            optionsStackContainer.bottomAnchor.constraint(equalTo: optionsView.bottomAnchor, constant: -Constants.padding.bottom),
            
            optionsStackView.topAnchor.constraint(equalTo: optionsStackContainer.topAnchor),
            optionsStackView.leadingAnchor.constraint(equalTo: optionsStackContainer.leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: optionsStackContainer.trailingAnchor),
            optionsStackView.bottomAnchor.constraint(equalTo: optionsStackContainer.bottomAnchor),
        ])
    }
    
    func setExpanded(_ expanded: Bool, animated: Bool) {
        guard viewData?.expanded != expanded else { return }
        
        viewData?.expanded = expanded
        
        NSLayoutConstraint.deactivate(expandDependentConstraints)
        expandDependentConstraints.removeAll()
        
        if expanded {
            expandDependentConstraints.append(
                optionsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            )
        }
        else {
            expandDependentConstraints.append(
                containerView.heightAnchor.constraint(equalTo: headView.heightAnchor)
            )
        }

        let rotateArrowBlock = {
            if expanded {
                self.arrowView.transform = .identity
            }
            else {
                self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat.pi)
            }
        }
        NSLayoutConstraint.activate(self.expandDependentConstraints)
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                rotateArrowBlock()
            }
        }
        else {
            rotateArrowBlock()
        }
    }

    func apply(viewModel: MenuDropDownViewData) {
        selectionStyle = .none
        
        let optionsWereChanged = {
            guard
                self.viewData?.options.count == viewModel.options.count
            else {
                return true
            }
            for i in 0..<viewModel.options.count {
                let existingOption = self.viewData?.options[i]
                let newOption = viewModel.options[i]
                
                if existingOption?.itemId != newOption.itemId {
                    return true
                }
            }
            
            return false
        }()
        viewData = viewModel
        
        NSLayoutConstraint.deactivate(contentDependentConstraints)

        guard
            let viewData,
            !viewData.options.isEmpty
        else {
            topDivider.isHidden = true
            return
        }
        
        mainTextLabel.text = viewModel.title
        optionsDescriptionLabel.text = viewModel.description
        topDivider.isHidden = false
        leftIconView.image = viewModel.iconImage
        
        if optionsWereChanged {
            optionViews.removeAll()
            for subview in optionsStackView.arrangedSubviews {
                optionsStackView.removeArrangedSubview(subview)
            }
            for option in viewData.options {
                let optionView = ItemView()
                optionView.delegate = self
                optionViews.append(optionView)
                optionView.apply(viewData: option)
                
                if option.itemId == viewData.selectedItemId {
                    selectedOptionLabel.text = option.title
                    optionView.setSelected(true)
                }
                else {
                    optionView.setSelected(false)
                }
                optionsStackView.addArrangedSubview(optionView)
            }
        }
        
        NSLayoutConstraint.activate(contentDependentConstraints)
    }
    
    func updateSelectedOption(viewModel: MenuDropDownViewData) {
        var optionsByIds: [String: MenuDropDownViewData.Item] = [:]
        for item in viewData?.options ?? [] {
            optionsByIds[item.itemId] = item
        }
        
        for optionView in optionViews {
            if let id = optionView.viewData?.itemId,
               let option = optionsByIds[id] {
                optionView.apply(viewData: option)
                if option.itemId == viewModel.selectedItemId {
                    selectedOptionLabel.text = option.title
                    optionView.setSelected(true)
                }
                else {
                    optionView.setSelected(false)
                }
            }
        }
    }
}

extension MenuDropDownCell: ItemViewDelegate {
    func didTappedItem(id: String) {
        guard let viewData else { return }
        
        viewData.selectedItemId = id
        updateSelectedOption(viewModel: viewData)
    }
}
