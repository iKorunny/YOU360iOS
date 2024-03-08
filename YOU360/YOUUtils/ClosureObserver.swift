//
//  ClosureObserver.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 3/8/24.
//

import Foundation

public final class ClosureObserver {
    public let closure: (() -> Void)
    
    public init(closure: @escaping () -> Void) {
        self.closure = closure
    }
}
