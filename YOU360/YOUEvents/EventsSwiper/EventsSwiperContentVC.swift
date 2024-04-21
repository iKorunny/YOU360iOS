//
//  EventsSwiperContentVC.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/21/24.
//

import UIKit
import YOUUtils

final class EventsSwiperContentVC: UIViewController {
    private enum Constants {
        static let lineHeight: CGFloat = 3
        static let lineTopOffset: CGFloat = 4
    }
    
    private lazy var lineVC: EventsSwiperStoryLineVC = {
        let vc = EventsSwiperStoryLineVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorPallete.appWhiteSecondary
        
        lineVC.willMove(toParent: self)
        
        view.addSubview(lineVC.view)
        lineVC.view.heightAnchor.constraint(equalToConstant: Constants.lineHeight).isActive = true
        lineVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lineVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lineVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.lineTopOffset).isActive = true
        
        addChild(lineVC)
        lineVC.didMove(toParent: self)
    }
    
    func reload() {
        lineVC.redraw(with: 7)
        lineVC.set(activeIndex: 0)
    }
}
