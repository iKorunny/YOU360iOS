//
//  TableViewInputFocusService.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 4/16/24.
//

import Foundation
import UIKit

public protocol TableViewInputScrollerDelegate: AnyObject {
    func indexPath(for type: TableViewInputScrollerType) -> IndexPath?
}

public enum TableViewInputScrollerType {
    case keyboard
    case date
}

public final class TableViewInputScrollerService {
    private enum Constants {
        static let inputViewShowHideAnimationDuration: TimeInterval = 0.3
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private let mainView: UIView
    private let tableView: UITableView
    private let bottomConstraint: NSLayoutConstraint
    private let defaultBottomOffset: CGFloat
    private weak var delegate: TableViewInputScrollerDelegate?
    
    public init(mainView: UIView,
                tableView: UITableView,
                bottomConstraint: NSLayoutConstraint,
                delegate: TableViewInputScrollerDelegate) {
        self.mainView = mainView
        self.tableView = tableView
        self.bottomConstraint = bottomConstraint
        self.defaultBottomOffset = bottomConstraint.constant
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        reset()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard  let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        onShowInputView(with: keyboardHeight, type: .keyboard)
    }
    
    public func onShowInputView(with height: CGFloat, type: TableViewInputScrollerType) {
        let editingCellPath: IndexPath? = delegate?.indexPath(for: type)
        
        bottomConstraint.constant = -height
        UIView.animate(withDuration: Constants.inputViewShowHideAnimationDuration) { [weak self] in
            self?.mainView.layoutIfNeeded()
        } completion: { [weak self] _ in
            guard let editingCellPath else { return }
            self?.tableView.scrollToRow(at: editingCellPath, at: .bottom, animated: true)
        }
    }
    
    public func reset() {
        bottomConstraint.constant = defaultBottomOffset
        UIView.animate(withDuration: Constants.inputViewShowHideAnimationDuration) { [weak self] in
            self?.mainView.layoutIfNeeded()
        }
    }
}
