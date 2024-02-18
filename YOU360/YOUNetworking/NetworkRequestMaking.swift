//
//  NetworkRequestMaking.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation

public protocol NetworkRequestMaking {
    func makeDatataskRequest()
}

public final class NetworkRequestMaker: NetworkRequestMaking {
    
    static var shared = {
       return NetworkRequestMaker()
    }()
    
    public func makeDatataskRequest() {
        
    }
}
