//
//  URLResponse+Extension.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/22/24.
//

import Foundation

public extension URLResponse {
    var isSuccess: Bool {
        guard let httpResponse = self as? HTTPURLResponse else { return false }
        return httpResponse.statusCode == 200
    }
}
