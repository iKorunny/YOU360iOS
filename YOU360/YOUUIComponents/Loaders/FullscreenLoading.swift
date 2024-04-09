//
//  FullscreenLoading.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/27/24.
//

import Foundation
import UIKit

public protocol FullscreenLoading {
    func present(from vc: UIViewController)
    func remove(completion: (() -> Void)?)
}
