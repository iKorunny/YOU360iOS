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

private enum Constants {
    static let animationDuration: CFTimeInterval = 0.8
    static let animationTypeKey: String = "cube"
    static let animationKey: String = "layerCubicAnimationKey"
}

public final class CubicAnimator<T: AnyObject>: NSObject, CAAnimationDelegate {
    private let animationOnView: UIView
    private let completion: (T?) -> Void
    
    private weak var oldItem: T?
    
    public init(animationOnView: UIView, completion: @escaping (T?) -> Void) {
        self.animationOnView = animationOnView
        self.completion = completion
        super.init()
    }
    
    public func animate(with direction: CubicAnimatorDirection, 
                        currentItem: T?,
                        animationBlock: (() -> Void)) {
        oldItem = currentItem
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
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion(flag ? oldItem : nil)
    }
}
