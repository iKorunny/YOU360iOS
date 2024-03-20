//
//  YOUNativeDatePickerVC.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 3/18/24.
//

import UIKit
import YOUUtils

final class YOUNativeDatePickerVC: UIViewController {
    deinit {
        hideGestures.forEach { view.removeGestureRecognizer($0) }
    }
    
    var onDateChanged: ((Date?) -> Void)?
    var onWillDismiss: (() -> Void)?
    
    private(set) lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        
        picker.setValue(ColorPallete.appBlackSecondary, forKey: "textColor")
        picker.addAction(UIAction(handler: { [weak self] _ in
            self?.didSelect(date: picker.date)
        }), for: .valueChanged)
        
        picker.maximumDate = Date()
        return picker
    }()
    
    private lazy var hideGestures: [UIGestureRecognizer] = {
       return [
        UITapGestureRecognizer(target: self, action: #selector(hide)),
        UIPanGestureRecognizer(target: self, action: #selector(hide))
       ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        
        hideGestures.forEach { view.addGestureRecognizer($0) }
        
        let pickerBackgroundView = UIView()
        pickerBackgroundView.backgroundColor = ColorPallete.appWhiteSecondary
        pickerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerBackgroundView)
        
        pickerBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        pickerBackgroundView.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: pickerBackgroundView.topAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: pickerBackgroundView.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: pickerBackgroundView.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: pickerBackgroundView.bottomAnchor).isActive = true
    }
    
    func present(from vc: UIViewController, currentDate: Date?) {
        if let currentDate {
            datePicker.setDate(currentDate, animated: false)
        }
        vc.parent?.present(self, animated: true)
    }
    
    @objc private func hide() {
        dismiss(animated: true)
    }
    
    private func didSelect(date: Date?) {
        onDateChanged?(date)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        onWillDismiss?()
        super.dismiss(animated: flag, completion: completion)
    }
}
