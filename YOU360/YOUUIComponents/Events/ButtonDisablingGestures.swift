//
//  ButtonDisablingGestures.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 5/1/24.
//

import UIKit

public class ButtonDisablingGestures: UIButton {
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
