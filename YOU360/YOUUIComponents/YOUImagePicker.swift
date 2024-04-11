//
//  YOUImagePicker.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 3/17/24.
//

import Foundation
import UIKit
import YOUUtils

public enum YOUImagePickerType {
    case avatar
    case banner
    case contentImage
    case none
}

public protocol YOUImagePicker {
    func present(from vc: UIViewController, type: YOUImagePickerType)
}

public protocol YOUImagePickerDelegate: AnyObject {
    func didPick(image: UIImage?, type: YOUImagePickerType)
}

public final class YOUNativeImagePicker: NSObject, YOUImagePicker {
    private var type: YOUImagePickerType = .none
    private weak var delegate: YOUImagePickerDelegate?
    
    private var allowEditingOnPicker: Bool {
        switch type {
        case .avatar, .contentImage:
            return true
        default:
            return false
        }
    }
    
    public init(delegate: YOUImagePickerDelegate) {
        self.delegate = delegate
    }
    
    public func present(from vc: UIViewController, type: YOUImagePickerType) {
        self.type = type
        let nativePicker = UIImagePickerController()
        nativePicker.allowsEditing = allowEditingOnPicker
        nativePicker.delegate = self
        vc.present(nativePicker, animated: true)
    }
}

extension YOUNativeImagePicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.delegate?.didPick(image: nil, type: self.type)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, 
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var pickedImage: UIImage?
        switch type {
        case .avatar:
            if let newImage = info[.editedImage] as? UIImage {
                pickedImage = UIImageResizer.resizeTo720p(image: newImage)
            }
        case .banner:
            if let newImage = info[.originalImage] as? UIImage {
                pickedImage = UIImageResizer.resizeTo1080p(image: newImage)
            }
        case .contentImage:
            pickedImage = info[.editedImage] as? UIImage
        default: break
        }
        picker.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.delegate?.didPick(image: pickedImage, type: self.type)
        }
    }
}
