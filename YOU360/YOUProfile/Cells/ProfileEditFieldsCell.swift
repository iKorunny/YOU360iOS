//
//  ProfileEditFieldsCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/10/24.
//

import UIKit
import YOUUtils

final class ProfileEditFieldsCell: UITableViewCell {
    private var fieldsContentView: ProfileEditFieldsContentView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        fieldsContentView?.removeFromSuperview()
    }
    
    func apply(model: ProfileEditFieldsContentViewModel) {
        fieldsContentView?.removeFromSuperview()
        
        let newContentView = ProfileEditFieldsContentView(viewModel: model)
        newContentView.translatesAutoresizingMaskIntoConstraints = false
        self.fieldsContentView = newContentView
        contentView.addSubview(newContentView)
        
        newContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        newContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        newContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        newContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
