//
//  LoginStartVC.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/18/24.
//

import UIKit
import YOUUtils

final class LoginStartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.red
        
        _ = YOUFontsProvider.appRegularFont(with: 12)
    }
}
