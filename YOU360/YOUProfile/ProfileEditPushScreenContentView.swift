//
//  ProfileEditPushScreenContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/15/24.
//

import UIKit
import YOUUtils

final class ProfileEditPushScreenLineModel {
    let identifier: String
    let placeholderFont: UIFont
    let placeholderColor: UIColor
    let placeholder: String?
    
    var text: String?
    let textFont: UIFont
    let textColor: UIColor
    
    let action: (() -> Void)
    
    init(identifier: String, 
         placeholderFont: UIFont,
         placeholderColor: UIColor,
         placeholder: String?,
         text: String? = nil,
         textFont: UIFont,
         textColor: UIColor,
         action: @escaping (() -> Void)) {
        self.identifier = identifier
        self.placeholderFont = placeholderFont
        self.placeholderColor = placeholderColor
        self.placeholder = placeholder
        self.text = text
        self.textFont = textFont
        self.textColor = textColor
        self.action = action
    }
}

final class ProfileEditPushScreenContentViewModel {
    let models: [ProfileEditPushScreenLineModel]
    
    init(models: [ProfileEditPushScreenLineModel]) {
        self.models = models
    }
    
    func tag(for model: ProfileEditPushScreenLineModel) -> Int? {
        return models.firstIndex(where: { $0.identifier == model.identifier })
    }
}

final class ProfileEditPushScreenContentView: UIView {
    private var viewModel: ProfileEditPushScreenContentViewModel?
    
    private enum Constants {
        static let containerCornerRadius: CGFloat = 16
        static let containerInsets: UIEdgeInsets = .init(top: 12, left: 20, bottom: 0, right: 20)
        
        static let lineHeight: CGFloat = 48
        static let lineOffset: CGFloat = 0
        static let separatorHeight: CGFloat = 1
    }
    
    private lazy var linesContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorPallete.appWhite
        container.layer.masksToBounds = true
        container.layer.cornerRadius = Constants.containerCornerRadius
        let heightConstraint = container.heightAnchor.constraint(equalToConstant: .zero)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        return container
    }()
    
    convenience init(viewModel: ProfileEditPushScreenContentViewModel) {
        self.init(frame: .zero, viewModel: viewModel)
    }
    
    init(frame: CGRect, viewModel: ProfileEditPushScreenContentViewModel) {
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
        guard let lineModels = viewModel?.models, !lineModels.isEmpty else { return }
        addSubview(linesContainer)
        
        linesContainer.topAnchor.constraint(equalTo: topAnchor, constant: Constants.containerInsets.top).isActive = true
        linesContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        linesContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.containerInsets.left).isActive = true
        linesContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.containerInsets.right).isActive = true
        
        var previousView: UIView?
        lineModels.forEach { lineModel in
            guard let firstModel = lineModels.first,
                  let lastModel = lineModels.last else { return }
            let line = line(for: lineModel)
            let isFirst = firstModel === lineModel
            let isLast = lastModel === lineModel
            
            linesContainer.addSubview(line)
            
            if isFirst {
                line.topAnchor.constraint(equalTo: linesContainer.topAnchor).isActive = true
            }
            else if let previousView {
                let separator = UIView()
                linesContainer.addSubview(separator)
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.backgroundColor = ColorPallete.appWeakPink
                separator.heightAnchor.constraint(equalToConstant: Constants.separatorHeight).isActive = true
                separator.leadingAnchor.constraint(equalTo: previousView.leadingAnchor).isActive = true
                separator.trailingAnchor.constraint(equalTo: previousView.trailingAnchor).isActive = true
                separator.topAnchor.constraint(equalTo: previousView.bottomAnchor).isActive = true
                
                line.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
            }
            
            if isLast {
                line.bottomAnchor.constraint(equalTo: linesContainer.bottomAnchor).isActive = true
            }
            
            line.leadingAnchor.constraint(equalTo: linesContainer.leadingAnchor, constant: Constants.lineOffset).isActive = true
            line.trailingAnchor.constraint(equalTo: linesContainer.trailingAnchor, constant: -Constants.lineOffset).isActive = true
            previousView = line
        }
    }
    
    private func line(for model: ProfileEditPushScreenLineModel) -> ProfileEditPushScreenLineView {
        let view = ProfileEditPushScreenLineView(model: model)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: Constants.lineHeight).isActive = true
        return view
    }
}
