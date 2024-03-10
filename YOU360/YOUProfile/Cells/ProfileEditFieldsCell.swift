//
//  ProfileEditFieldsCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/10/24.
//

import UIKit
import YOUUtils

final class ProfileEditFieldsCell: UITableViewCell {
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
}
