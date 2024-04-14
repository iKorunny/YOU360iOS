//
//  AlertsPresenter.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 4/7/24.
//

import Foundation
import UIKit
import YOUUtils

public final class AlertsPresenter {
    public static func presentSomethingWentWrongAlert(from vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: "AlertSomethingWentWrong".localised(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ALertOkButton".localised(), style: .cancel))
        vc.present(alert, animated: true)
    }
}
