//
//  EstablishmentsScreenFactory.swift
//  YOUEstablishments
//
//  Created by Ihar Karunny on 3/3/24.
//

import Foundation
import UIKit
import YOUUIComponents

public final class EstablishmentsScreenFactory {
    public static func createTopRootVC() -> UIViewController {
        return YOUNavigationController(rootViewController: UIViewController(), type: .top)
    }
}
