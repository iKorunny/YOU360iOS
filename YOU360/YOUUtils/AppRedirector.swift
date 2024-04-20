//
//  AppRedirector.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/20/24.
//

import Foundation
import UIKit

public final class AppRedirector {
    public static func toSettings() {
        guard let url = URL(string:UIApplication.openSettingsURLString), 
                UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
