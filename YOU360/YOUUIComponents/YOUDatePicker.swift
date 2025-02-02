//
//  YOUDatePicker.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 3/18/24.
//

import Foundation
import UIKit

public protocol YOUDatePicker {
    func present(from vc: UIViewController, with date: Date?)
    func dismiss()
    var dateDidChange: ((Date?) -> Void)? { get set }
    var onWillFinishEditing: (() -> Void)? { get set }
    var pickerHeight: CGFloat { get }
}

public final class YOUNativeDatePicker: NSObject, YOUDatePicker {
    public var pickerHeight: CGFloat { datePickerVC.datePicker.bounds.height }
    
    public var onWillFinishEditing: (() -> Void)?
    public var dateDidChange: ((Date?) -> Void)?
    
    private lazy var datePickerVC: YOUNativeDatePickerVC = {
        let vc = YOUNativeDatePickerVC()
        vc.onWillDismiss = { [weak self] in
            self?.onWillFinishEditing?()
        }
        vc.onDateChanged = { [weak self] date in
            self?.dateDidChange?(date)
        }
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }()
    
    public func present(from vc: UIViewController, with date: Date?) {
        datePickerVC.present(from: vc, currentDate: date)
    }
    
    public func dismiss() {
        datePickerVC.dismiss(animated: true)
    }
}
