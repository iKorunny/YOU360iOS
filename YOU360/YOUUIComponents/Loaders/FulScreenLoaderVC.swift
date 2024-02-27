//
//  FulScreenLoaderVC.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/27/24.
//

import UIKit

public final class FulScreenLoaderVC: UIViewController {
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(indicatorView)
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        indicatorView.startAnimating()
    }
}

extension FulScreenLoaderVC: FullscreenLoading {
    public func present(from vc: UIViewController) {
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        vc.present(self, animated: true)
    }
    
    public func remove() {
        dismiss(animated: true)
    }
}
