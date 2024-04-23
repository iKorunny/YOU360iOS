//
//  CubicAnimator.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/23/24.
//

import Foundation
import QuartzCore
import UIKit

public enum CubicAnimatorDirection {
    case fromLeft
    case fromRight
}

public final class CubicAnimator: NSObject {
    private enum Constants {
        static let animationDuration: CFTimeInterval = 4//0.8
        static let animationTypeKey: String = "cube"
        static let animationKey: String = "layerAnimationKey"
    }
    
    private let animationOnView: UIView
    private let completion: (UIViewController?) -> Void
    
    private weak var oldVC: UIViewController?
    
    public init(animationOnView: UIView, completion: @escaping (UIViewController?) -> Void) {
        self.animationOnView = animationOnView
        self.completion = completion
        super.init()
    }
    
    public func animate(with direction: CubicAnimatorDirection, 
                        currentVC: UIViewController?,
                        animationBlock: (() -> Void)) {
        oldVC = currentVC
        let transition = CATransition()
        transition.delegate = self
        transition.duration = Constants.animationDuration
        transition.timingFunction = .init(name: .easeInEaseOut)
        transition.type = .init(rawValue: Constants.animationTypeKey)
        transition.startProgress = 0
        transition.endProgress = 1
        
        switch direction {
        case .fromLeft:
            transition.subtype = .fromLeft
        case .fromRight:
            transition.subtype = .fromRight
        }
        
        animationOnView.layer.add(transition, forKey: Constants.animationKey)
        animationBlock()
    }
}

extension CubicAnimator: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion(flag ? oldVC : nil)
    }
}
