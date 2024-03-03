//
//  ChatScreenFactory.swift
//  YOUChat
//
//  Created by Ihar Karunny on 3/3/24.
//

import Foundation
import UIKit
import YOUUIComponents

public final class ChatScreenFactory {
    public static func createChatRootVC() -> UIViewController {
        return YOUNavigationController(rootViewController: UIViewController(), type: .chat)
    }
}
