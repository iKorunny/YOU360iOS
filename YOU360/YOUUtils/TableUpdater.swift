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
        beginUpdatesIfNeeded()
        closure()
        endUpdatesIfNeeded()
    }
    
    public static func update(table: UITableView?, closure: (() -> Void)) {
        beginUpdatesIfNeeded(table: table)
        closure()
        endUpdatesIfNeeded(table: table)
    }
    
    private func beginUpdatesIfNeeded() {
        guard table?.window != nil else { return }
        table?.beginUpdates()
    }
    
    private func endUpdatesIfNeeded() {
        guard table?.window != nil else { return }
        table?.endUpdates()
    }
    
    private static func beginUpdatesIfNeeded(table: UITableView?) {
        guard table?.window != nil else { return }
        table?.beginUpdates()
    }
    
    private static func endUpdatesIfNeeded(table: UITableView?) {
        guard table?.window != nil else { return }
        table?.endUpdates()
    }
}
