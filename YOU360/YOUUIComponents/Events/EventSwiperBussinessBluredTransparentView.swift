//
//  EventSwiperBussinessBluredTransparentView.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/30/24.
//

import UIKit
import YOUUtils

public final class EventSwiperBussinessBluredTransparentView: UIView {
    
    private enum Constants {
        static let contentInsets = UIEdgeInsets(top: 17, left: 16, bottom: -16, right: -16)
        static let buttonsTopOffset: CGFloat = 16
        static let likesLabelFontSize: CGFloat = 14
        static let likesLabelLeftOffset: CGFloat = 4
        static let nameLabelFontSize: CGFloat = 22
        static let addressLabelFontSize: CGFloat = 14
        static let categoryLabelFontSize: CGFloat = 14
        static let categotyTopOffset: CGFloat = 4
        static let categoryLabelLeftOffset: CGFloat = 4
        static let buttonsSpacing: CGFloat = 13
        static let buttonsStackHeight: CGFloat = 44
        static let roundButtonsSpacing: CGFloat = 9
        static let guestListButtonTextSize: CGFloat = 12
        static let guestListButtonCornerRadius: CGFloat = 12
        static let guestListButtonIconPaddig: CGFloat = 4
    }

    public static func create() -> EventSwiperBussinessBluredTransparentView {
        let view = EventSwiperBussinessBluredTransparentView()
        view.setup()
        return view
    }
    
    public override var frame: CGRect {
        didSet {
            updateMask()
        }
    }
    
    public override var bounds: CGRect {
        didSet {
            updateMask()
        }
    }
    
    private lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    private lazy var likesIcon: UIImageView = {
        let imageView = UIImageView(image: .init(named: "EventLikesIcon"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = ColorPallete.appPink
        label.font = YOUFontsProvider.appBoldFont(with: Constants.likesLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = ColorPallete.appWhite3
        label.textAlignment = .left
        label.font = YOUFontsProvider.appBoldFont(with: Constants.nameLabelFontSize)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = ColorPallete.appWhite3
        label.textAlignment = .left
        label.font = YOUFontsProvider.appRegularFont(with: Constants.addressLabelFontSize)
        return label
    }()
    
    private lazy var categoryIcon: UIImageView = {
        let imageView = UIImageView(image: .init(named: "EventCategoryIcon"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = ColorPallete.appWhite3
        label.font = YOUFontsProvider.appBoldFont(with: Constants.categoryLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var buttonsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = Constants.buttonsSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var smallButtonsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = Constants.roundButtonsSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var onGuestList: (() -> Void)?
    private var onTaxi: (() -> Void)?
    private var onLike: (() -> Void)?
    private var onExpand: (() -> Void)?

    private func setup() {
        backgroundColor = .clear
        
        addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(likesIcon)
        likesIcon.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentInsets.top).isActive = true
        likesIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        
        addSubview(likesLabel)
        likesLabel.leadingAnchor.constraint(equalTo: likesIcon.trailingAnchor, constant: Constants.likesLabelLeftOffset).isActive = true
        likesLabel.centerYAnchor.constraint(equalTo: likesIcon.centerYAnchor).isActive = true
        
        addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.contentInsets.right).isActive = true
        nameLabel.topAnchor.constraint(equalTo: likesIcon.bottomAnchor).isActive = true
        
        addSubview(addressLabel)
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.contentInsets.right).isActive = true
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        addSubview(categoryIcon)
        categoryIcon.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: Constants.categotyTopOffset).isActive = true
        categoryIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        
        addSubview(categoryLabel)
        categoryLabel.leadingAnchor.constraint(equalTo: categoryIcon.trailingAnchor, constant: Constants.categoryLabelLeftOffset).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: categoryIcon.centerYAnchor).isActive = true
        
        addSubview(buttonsContainer)
        buttonsContainer.topAnchor.constraint(equalTo: categoryIcon.bottomAnchor, constant: Constants.buttonsTopOffset).isActive = true
        buttonsContainer.heightAnchor.constraint(equalToConstant: Constants.buttonsStackHeight).isActive = true
        buttonsContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        buttonsContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.contentInsets.right).isActive = true
        buttonsContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.contentInsets.bottom).isActive = true
        
        updateMask()
    }
    
    public func set(likes: Int,
                    name: String,
                    address: String?,
                    category: String?,
                    onGuestList: (() -> Void)?,
                    onTaxi: (() -> Void)?,
                    onLike: (() -> Void)?,
                    onExpand: (() -> Void)?) {
        likesLabel.text = Formatters.formatShorForm(of: likes)
        nameLabel.text = name
        addressLabel.text = address
        categoryLabel.text = category
        
        self.onGuestList = onGuestList
        self.onTaxi = onTaxi
        self.onLike = onLike
        self.onExpand = onExpand
        
        updateButtons()
    }
    
    private func updateButtons() {
        buttonsContainer.arrangedSubviews.forEach {
            buttonsContainer.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        smallButtonsContainer.arrangedSubviews.forEach {
            smallButtonsContainer.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        if onGuestList != nil {
            buttonsContainer.addArrangedSubview(makeGuestListButton())
        }
        
        if onTaxi != nil {
            buttonsContainer.addArrangedSubview(makeTaxiButton())
        }
        
        if onLike != nil {
            smallButtonsContainer.addArrangedSubview(makeLikeButton())
        }
        
        if onExpand != nil {
            smallButtonsContainer.addArrangedSubview(makeExpandButton())
        }
        
        if !smallButtonsContainer.arrangedSubviews.isEmpty {
            buttonsContainer.addArrangedSubview(smallButtonsContainer)
        }
    }
    
    private func makeGuestListButton() -> UIButton {
        return ButtonsFactory.createButtonDisablingGestures(
            backgroundColor: ColorPallete.appWhite4,
            highlightedBackgroundColor: ColorPallete.appDarkWhite,
            title: "EventsGuestListButton".localised(),
            titleFont: YOUFontsProvider.appSemiBoldFont(with: Constants.guestListButtonTextSize),
            titleColor: ColorPallete.appBlackSecondary,
            titleIcon: UIImage(named: "EventGuestListIcon"),
            iconPadding: Constants.guestListButtonIconPaddig,
            height: Constants.buttonsStackHeight,
            cornerRadius: Constants.guestListButtonCornerRadius,
            target: self,
            action: #selector(guestListAction)
        )
    }
    
    private func makeTaxiButton() -> UIButton {
        let button = ButtonDisablingGestures()
        button.setBackgroundImage(UIImage(named: "EventTaxiIcon"), for: .normal)
        button.addTarget(self, action: #selector(taxiAction), for: .touchUpInside)
        return button
    }
    
    private func makeLikeButton() -> UIButton {
        let button = ButtonDisablingGestures()
        button.setBackgroundImage(UIImage(named: "EventMyLikeIcon"), for: .normal)
        button.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        return button
    }
    
    private func makeExpandButton() -> UIButton {
        let button = ButtonDisablingGestures()
        button.setBackgroundImage(UIImage(named: "EventToBussinessIcon"), for: .normal)
        button.addTarget(self, action: #selector(expandAction), for: .touchUpInside)
        return button
    }
    
    @objc private func guestListAction() {
        onGuestList?()
    }
    
    @objc private func taxiAction() {
        onTaxi?()
    }
    
    @objc private func likeAction() {
        onLike?()
    }
    
    @objc private func expandAction() {
        onExpand?()
    }
    
    private func updateMask() {
        if let oldMask = layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            oldMask.removeFromSuperlayer()
        }
        
        let mask = CAGradientLayer()
        mask.startPoint = CGPointMake(0.5, 1.0)
        mask.endPoint = CGPointMake(0.5, 0.0)
        let color = UIColor.white
        mask.colors = [
            color.cgColor,
            color.cgColor,
            color.withAlphaComponent(0.0).cgColor]
        mask.locations = [
            NSNumber(value: 0.0),
            NSNumber(value: (184 - 17.0) / 184),
            NSNumber(value: 1.0)]
        mask.frame = bounds
        layer.addSublayer(mask)
        layer.mask = mask
    }
    
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let result = super.gestureRecognizerShouldBegin(gestureRecognizer)
        
        if gestureRecognizer is UILongPressGestureRecognizer {
            return false
        }
        
        return result
    }
}
