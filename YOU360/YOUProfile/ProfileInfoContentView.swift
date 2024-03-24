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
    let age: String?
    
    init(name: String, 
         desciption: String?,
         address: String?,
         age: String?) {
        self.name = name
        self.desciption = desciption
        self.address = address
        self.age = age
    }
}

final class ProfileInfoContentView: UIView {
    
    private enum Constants {
        static let contentVerticalSpacing: CGFloat = 20
        static let contentTopOffset: CGFloat = 12
        static let contentBottomOffset: CGFloat = 14
        static let descriptionTopOffset: CGFloat = 4
        static let descriptionBottomOffset: CGFloat = 11
        static let ageTopOffset: CGFloat = 7
        
        static let nameFont: UIFont = YOUFontsProvider.appBoldFont(with: 22)
        static let descriptionFont: UIFont = YOUFontsProvider.appSemiBoldFont(with: 14)
        static let addressAgeFont: UIFont = YOUFontsProvider.appMediumFont(with: 14)
    }

    private var viewModel: ProfileInfoContentViewModel?

    func apply(viewModel: ProfileInfoContentViewModel) {
        
    }
    
    static func calculateHeight(from width: CGFloat) -> CGFloat {
        return 100
        //return width / 375 * 222 + Constants.avatarBackgroundBottomOffset
    }
}
