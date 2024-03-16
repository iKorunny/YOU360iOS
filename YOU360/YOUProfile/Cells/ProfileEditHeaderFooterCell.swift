//
//  ProfileEditHeaderFooterCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/16/24.
//

import UIKit
import YOUUtils

final class ProfileEditHeaderFooterCell: UITableViewCell {

    private var headerFooterContentView: ProfileEditHeaderFooterContentView?
    
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
        
        headerFooterContentView?.removeFromSuperview()
    }
    
    func apply(model: ProfileEditHeaderFooterContentViewModel) {
        headerFooterContentView?.removeFromSuperview()
        
        let newContentView = ProfileEditHeaderFooterContentView(viewModel: model)
        newContentView.translatesAutoresizingMaskIntoConstraints = false
        self.headerFooterContentView = newContentView
        contentView.addSubview(newContentView)
        
        newContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        newContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        newContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        newContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

}
