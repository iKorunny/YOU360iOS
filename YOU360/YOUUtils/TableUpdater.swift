//
//  TableUpdater.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/18/24.
//

import Foundation
import UIKit

public final class TableUpdater {
    private let table: UITableView?
    public init(table: UITableView?) {
        self.table = table
    }
    
    public func update(closure: (() -> Void)) {
        table?.beginUpdates()
        closure()
        table?.endUpdates()
    }
    
    public static func update(table: UITableView?, closure: (() -> Void)) {
        table?.beginUpdates()
        closure()
        table?.endUpdates()
    }
}
