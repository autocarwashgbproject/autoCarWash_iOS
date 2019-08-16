//
//  ExtensionViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 10/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
//    Установка логотипа в НавБар
    func setNavBarImage() {
        if let navVC = navigationController {
            let logoImage = #imageLiteral(resourceName: "carWash_logo")
            let width = navVC.navigationBar.frame.width
            let height = navVC.navigationBar.frame.height
            let logoContainer = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            logoContainer.image = logoImage
            logoContainer.contentMode = .bottom
            navigationItem.titleView = logoContainer
        }
    }
    
    //    Алерт
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//    Скрытие кнопки "назад" в НавБар
    func hideNavBarItem() {
        navigationItem.hidesBackButton = true
    }
    
//    Выбор фото из фотогалереи
    func pickPhotoFromLibrary(imagePicker: UIImagePickerController) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}
