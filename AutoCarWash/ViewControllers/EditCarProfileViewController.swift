//
//  CarProfileViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 07/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import RealmSwift

class EditCarProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var carPicImageView: UIImageView!
    @IBOutlet weak var char1TextField: UITextField!
    @IBOutlet weak var char2TextField: UITextField!
    @IBOutlet weak var char3TextField: UITextField!
    @IBOutlet weak var char4TextField: UITextField!
    @IBOutlet weak var char5TextField: UITextField!
    @IBOutlet weak var char6TextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    let carPicPicker = UIImagePickerController()
    var carPic = UIImage()
    let service = Service()
    var car: Car?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        carPicPicker.delegate = self
        
        car = service.loadCarFromRealm()
        
        carPicImageView.image = service.loadImageFromDiskWith(fileName: "carPic")
        
        char1TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char2TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char3TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char4TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char5TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char6TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let carPicTap = UITapGestureRecognizer(target: self, action: #selector(changeCarPic(recognizer:)))
        carPicImageView.isUserInteractionEnabled = true
        carPicImageView.addGestureRecognizer(carPicTap)
    }
    
//    Изменение фото машины
//    - по нажатию на аватарку
    @objc func changeCarPic(recognizer: UITapGestureRecognizer) {
        pickPhotoFromLibrary(imagePicker: carPicPicker)
    }
    
//    - по нажатию на кнопу "Изменить фото"
    @IBAction func changeCarPic(_ sender: UIButton) {
        pickPhotoFromLibrary(imagePicker: carPicPicker)
    }
    
//    Удаление фото машины
    @IBAction func deleteCarPic(_ sender: Any) {
        service.saveImage(imageName: "carPic", image: #imageLiteral(resourceName: "circle_car"))
        carPicImageView.image = #imageLiteral(resourceName: "circle_car")
    }
    
//    Сохранение изменений данных машны
    @IBAction func saveChanges(_ sender: Any) {
        guard char1TextField.text != "",
              char2TextField.text != "",
              char3TextField.text != "",
              char4TextField.text != "",
              char5TextField.text != "",
              char6TextField.text != "",
            regionTextField.text != "" else { service.saveImage(imageName: "carPic", image: carPic); sendAlert(title: "", message: "Фото автомобиля обновлено"); return }
        let carNum = "\(char1TextField.text!)\(char2TextField.text!)\(char3TextField.text!)\(char4TextField.text!)\(char5TextField.text!)\(char6TextField.text!)\(regionTextField.text!)"
        let carNumSp = "\(char1TextField.text!) \(char2TextField.text!)\(char3TextField.text!)\(char4TextField.text!) \(char5TextField.text!)\(char6TextField.text!)"
        let reg = regionTextField.text!
        let car = Car()
        car.regNum = carNum
        car.regNumSpaces = carNumSp
        car.region = reg
        car.isActive = true
        car.registrationDate = service.dateToUnixtime(date: Date())
        service.saveDataInRealmWithDeletingOld(object: car, objectType: Car.self)
        service.saveImage(imageName: "carPic", image: carPic)
        sendAlert(title: "", message: "Данные автомобиля обновлены")
//        Отправляем на сервер новый номер машины
    }
    
//    Удаление машины
    @IBAction func deleteCar(_ sender: Any) {
        do {
            let realm = try Realm()
            let car = realm.objects(Car.self)
            realm.beginWrite()
            realm.delete(car)
            try realm.commitWrite()
        } catch {
            print(error)
        }
        char1TextField.text = ""
        char2TextField.text = ""
        char3TextField.text = ""
        char4TextField.text = ""
        char5TextField.text = ""
        char6TextField.text = ""
        regionTextField.text = ""
        sendAlert(title: "", message: "Данные автомобиля удалены. Введите новый номер")
//        Отправляем на сервер тзапрос об удалении машины
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 1 {
            let nextTextField = view.viewWithTag(textField.tag + 1) as! UITextField
            nextTextField.becomeFirstResponder()
        }
    }
    
//    Функции выбора карпика
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            carPicImageView.contentMode = .scaleAspectFill
            carPic = pickedImage
            carPicImageView.image = carPic
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
