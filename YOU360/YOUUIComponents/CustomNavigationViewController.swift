//
//  CustomNavigationViewController.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/20/24.
//

import UIKit
import YOUUtils

open class CustomNavigationViewController: UIViewController {
    private enum Constants {
        static let barHeight: CGFloat = 44
        static let barTopOffset: CGFloat = 52
        
        static let logoViewSize = CGSize(width: 75, height: 25)
        static let logoInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18)
        
        static let titleFontSize: CGFloat = 18
        
        static let logoViewTag = 1060704360
    }
    
    private lazy var logoImageView: UIImageView = {
        if let logoView =  navigationController?.navigationBar.subviews.first(where: { $0.tag == Constants.logoViewTag }) as? UIImageView {
            return logoView
        }
        
        let imageView = UIImageView(image: .init(named: "LOGOYOU360"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: Constants.logoViewSize.height).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.logoViewSize.width).isActive = true
        imageView.tag = Constants.logoViewTag
        return imageView
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = ColorPallete.appWhite
        setupUI()
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : ColorPallete.appBlackSecondary,
            NSAttributedString.Key.font : YOUFontsProvider.appSemiBoldFont(with: Constants.titleFontSize)
        ]

        let backBTN = UIBarButtonItem(image: UIImage(named: "NavigationBack"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupUI() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.addSubview(logoImageView)
        logoImageView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -Constants.logoInsets.right).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
    }
    
    @objc private func popBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension CustomNavigationViewController: UIGestureRecognizerDelegate {
    
}
