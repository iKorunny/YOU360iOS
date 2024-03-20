//
//  ProfileEditScreenFieldModel.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/20/24.
//

import Foundation

protocol ProfileEditScreenFieldModel {
    var indexPath: IndexPath? { get set }
    var isFirstResponder: Bool { get }
    func resignActive()
}
