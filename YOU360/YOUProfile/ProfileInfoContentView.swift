//
//  ProfileInfoContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/24/24.
//

import UIKit
import YOUUtils

final class ProfileInfoContentViewModel {
    let name: String
    let desciption: String?
    let address: String?
    let dateOfBirth: Date?
    
    init(name: String, 
         desciption: String?,
         address: String?,
         dateOfBirth: Date?) {
        self.name = name
        self.desciption = desciption
        self.address = address
        self.dateOfBirth = dateOfBirth
    }
}

final class ProfileInfoContentView: UIView {
    
    private enum Constants {
        static let contentHorizontalSpacing: CGFloat = 20
        static let contentTopOffset: CGFloat = 12
        static let contentBottomOffset: CGFloat = 16
        static let descriptionTopOffset: CGFloat = 4
        static let addressAgeTopOffset: CGFloat = 11
        static let ageTopOffset: CGFloat = 7
        
        static let nameFont: UIFont = YOUFontsProvider.appBoldFont(with: 22)
        static let descriptionFont: UIFont = YOUFontsProvider.appSemiBoldFont(with: 14)
        static let addressAgeFont: UIFont = YOUFontsProvider.appMediumFont(with: 14)
    }

    private var viewModel: ProfileInfoContentViewModel?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.nameFont
        label.textColor = ColorPallete.appBlackSecondary
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.descriptionFont
        label.textColor = ColorPallete.appGrey
        return label
    }()

    func apply(viewModel: ProfileInfoContentViewModel) {
        subviews.forEach { $0.removeFromSuperview() }
        self.viewModel = viewModel
        
        addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentHorizontalSpacing).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentHorizontalSpacing).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentTopOffset).isActive = true
        nameLabel.text = viewModel.name
        var previousView: UIView = nameLabel
        
        if let desciption = viewModel.desciption {
            addSubview(descriptionLabel)
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentHorizontalSpacing).isActive = true
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentHorizontalSpacing).isActive = true
            descriptionLabel.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: Constants.descriptionTopOffset).isActive = true
            descriptionLabel.text = desciption
            previousView = descriptionLabel
        }
        
        if let address = viewModel.address {
            let addressView = ProfileInfoIconWithTextView(model: .init(image: UIImage(named: "ProfileAddressIcon"), text: String(format: "ProfileAddress".localised(), address)))
            addressView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(addressView)
            addressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentHorizontalSpacing).isActive = true
            addressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentHorizontalSpacing).isActive = true
            addressView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: Constants.addressAgeTopOffset).isActive = true
            
            previousView = addressView
        }
        
        if let ageDate = viewModel.dateOfBirth, 
            let ageString = Formatters.ageFrom(birthdate: ageDate) {
            let ageView = ProfileInfoIconWithTextView(model: .init(image: UIImage(named: "ProfileAgeIcon"), text: String(format: "ProfileAge".localised(), ageString)))
            addSubview(ageView)
            ageView.translatesAutoresizingMaskIntoConstraints = false
            ageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentHorizontalSpacing).isActive = true
            ageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentHorizontalSpacing).isActive = true
            ageView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: viewModel.address == nil ? Constants.addressAgeTopOffset : Constants.ageTopOffset).isActive = true
            previousView = ageView
        }
        
        previousView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.contentBottomOffset).isActive = true
    }
    
    static func calculateHeight(from width: CGFloat, model: ProfileInfoContentViewModel) -> CGFloat {
        let actualWidth = width - Constants.contentHorizontalSpacing * 2
        var height = Constants.contentTopOffset
        
        let calculatedNameHeight = TextSizeCalculator.calculateSize(with: actualWidth, text: model.name, font: Constants.nameFont).height
        height += calculatedNameHeight
        
        if let desciption = model.desciption {
            height += Constants.descriptionTopOffset
            let calculatedDescriptionHeight = TextSizeCalculator.calculateSize(with: actualWidth, text: desciption, font: Constants.descriptionFont).height
            height += calculatedDescriptionHeight
        }
        
        if model.address != nil {
            height += Constants.addressAgeTopOffset
            height += ProfileInfoIconWithTextView.height()
        }
        
        if model.dateOfBirth != nil {
            height += (model.address == nil) ? Constants.addressAgeTopOffset : Constants.ageTopOffset
            height += ProfileInfoIconWithTextView.height()
        }
        
        height += Constants.contentBottomOffset
        
        return ceil(height)
    }
}
