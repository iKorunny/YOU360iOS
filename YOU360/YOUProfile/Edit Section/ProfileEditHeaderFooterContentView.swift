//
//  ProfileEditHeaderFooterContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/16/24.
//

import UIKit
import YOUUtils

enum ProfileEditHeaderFooterModelType {
    case header
    case footer
}

final class ProfileEditHeaderFooterModel {
    let type: ProfileEditHeaderFooterModelType
    let text: String?
    let font: UIFont
    let color: UIColor
    
    init(type: ProfileEditHeaderFooterModelType, 
         text: String?,
         font: UIFont,
         color: UIColor) {
        self.type = type
        self.text = text
        self.font = font
        self.color = color
    }
}

final class ProfileEditHeaderFooterContentViewModel {
    let models: [ProfileEditHeaderFooterModel]
    
    init(models: [ProfileEditHeaderFooterModel]) {
        self.models = models
    }
}

final class ProfileEditHeaderFooterContentView: UIView {
    private var viewModel: ProfileEditHeaderFooterContentViewModel?
    
    private enum Constants {
        static let footerLabelTopOffset: CGFloat = 8
        static let headerLabelTopOffset: CGFloat = 16
        
        static let labelLeadingOffset: CGFloat = 36
        static let labelTrailingOffset: CGFloat = -20
        
        static let footerLabelBottomOffset: CGFloat = 16
        static let footerLabelLastBottomOffset: CGFloat = 4
        
        static let headerLabelBottomOffset: CGFloat = 12
        static let headerLabelLastBottomOffset: CGFloat = 0
        
        static let separatorHeight: CGFloat = 1
        static let separatorOffset: CGFloat = 20
    }
    
    convenience init(viewModel: ProfileEditHeaderFooterContentViewModel) {
        self.init(frame: .zero, viewModel: viewModel)
    }
    
    init(frame: CGRect, viewModel: ProfileEditHeaderFooterContentViewModel) {
        super.init(frame: frame)
        self.viewModel = viewModel
        didLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didLoad() {
        setupUI()
    }
    
    private func setupUI() {
        guard let labelModels = viewModel?.models, !labelModels.isEmpty else { return }
        
        var previousView: UIView?
        var previousModel: ProfileEditHeaderFooterModel?
        labelModels.forEach { labelModel in
            guard let firstModel = labelModels.first,
                  let lastModel = labelModels.last else { return }
            let label = label(for: labelModel)
            let isFirst = firstModel === labelModel
            let isLast = lastModel === labelModel
            
            addSubview(label)
            
            if isFirst {
                label.topAnchor.constraint(equalTo: topAnchor, 
                                           constant: constant(for: labelModel.type, isLast: isLast, anchor: topAnchor)).isActive = true
            }
            else if let previousView , let previousModel {
                let separator = UIView()
                addSubview(separator)
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.backgroundColor = ColorPallete.appWeakPink
                separator.heightAnchor.constraint(equalToConstant: Constants.separatorHeight).isActive = true
                separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.separatorOffset).isActive = true
                separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.separatorOffset).isActive = true
                separator.topAnchor.constraint(equalTo: previousView.bottomAnchor,
                                               constant: constant(for: previousModel.type,
                                                                  isLast: false,
                                                                  anchor: bottomAnchor)).isActive = true
                
                label.topAnchor.constraint(equalTo: separator.bottomAnchor, 
                                           constant: constant(for: labelModel.type, isLast: isLast, anchor: topAnchor)).isActive = true
            }
            
            if isLast {
                label.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -constant(for: labelModel.type, isLast: isLast, anchor: bottomAnchor)).isActive = true
            }
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: constant(for: labelModel.type, isLast: isLast, anchor: leadingAnchor)).isActive = true
            label.trailingAnchor.constraint(equalTo: trailingAnchor, 
                                            constant: constant(for: labelModel.type, isLast: isLast, anchor: trailingAnchor)).isActive = true
            previousView = label
            previousModel = labelModel
        }
    }
    
    private func label(for model: ProfileEditHeaderFooterModel) -> UILabel {
        let label = UILabel()
        label.text = model.text
        label.textColor = model.color
        label.font = model.font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
    
    private func constant<T>(for labelType: ProfileEditHeaderFooterModelType, isLast: Bool, anchor: NSLayoutAnchor<T>) -> CGFloat {
        switch anchor {
        case topAnchor:
            switch labelType {
            case .footer: return Constants.footerLabelTopOffset
            case .header: return Constants.headerLabelTopOffset
            }
        case bottomAnchor:
            switch labelType {
            case .footer: return isLast ? Constants.footerLabelLastBottomOffset : Constants.footerLabelBottomOffset
            case .header: return isLast ? Constants.headerLabelLastBottomOffset : Constants.headerLabelBottomOffset
            }
        case leadingAnchor:
            return Constants.labelLeadingOffset
        case trailingAnchor:
            return Constants.labelTrailingOffset
        default: fatalError("Unsupported anchor: \(anchor) for ProfileEditHeaderFooterContentView")
        }
    }
}
