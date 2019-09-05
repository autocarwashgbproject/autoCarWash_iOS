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
    var oldCarPic = UIImage()
    let service = Service()
    let request = AlamofireRequests()
    var isCar = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        carPicPicker.delegate = self
        
        carPicImageView.image = service.loadImageFromDiskWith(fileName: "carPic")
        oldCarPic = carPicImageView.image!
        
        char1TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char2TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char3TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char4TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char5TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char6TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        regionTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let carPicTap = UITapGestureRecognizer(target: self, action: #selector(changeCarPic(recognizer:)))
        carPicImageView.isUserInteractionEnabled = true
        carPicImageView.addGestureRecognizer(carPicTap)
        
        setPlaceholders()
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
//        guard нет оплаченного аблнемента else { sendAlert(title: "Нельзя изменить номер автомобиля", message: "У Вас оплачен абонемент на пользование автомойкой. Пока подписка активна, номер автомобиля измннить нельзя"), return}
        guard char1TextField.text != "",
              char2TextField.text != "",
              char3TextField.text != "",
              char4TextField.text != "",
              char5TextField.text != "",
              char6TextField.text != "",
              regionTextField.text != "" else { if carPicImageView.image != oldCarPic {
                service.saveImage(imageName: "carPic", image: carPicImageView.image!)
                sendAlert(title: "Данные сохранены", message: "Фото автомобиля обновлено") };
                return
        }
        let carNum = "\(char1TextField.text!.uppercased())\(char2TextField.text!)\(char3TextField.text!)\(char4TextField.text!)\(char5TextField.text!.uppercased())\(char6TextField.text!.uppercased())\(regionTextField.text!)"
        if isCar {
            request.carSetDataRequest(regNum: carNum) { [weak self] carResponse in
                print("EDIT CAR: \(carResponse.toJSON())")
                guard carResponse.ok == true else { return }
                self?.service.saveImage(imageName: "carPic", image: self!.carPicImageView.image!)
                self?.sendAlert(title: "Данные сохранены", message: "Номер автомобиля успешно обновлён")
            }
        } else {
            request.carRegistrationRequest(regNum: carNum) { [weak self] carResponse in
                print("ADD NEW CAR: \(carResponse.toJSON())")
                guard carResponse.ok == true else { return }
                Session.session.carID = carResponse.id
                do {
                    let realm = try Realm()
                    let sessionInfo = realm.objects(SessionInfo.self).first!
                    try realm.write {
                        sessionInfo.setValue(carResponse.id, forKey: "carID")
                    }
                } catch {
                    print(error)
                }
                self?.service.saveImage(imageName: "carPic", image: self!.carPicImageView.image!)
                self?.sendAlert(title: "Данные сохранены", message: "Номер автомобиля успешно обновлён")
            }
        }
    }
    
//    Удаление машины
    @IBAction func deleteCar(_ sender: Any) {
        char1TextField.text = ""
        char2TextField.text = ""
        char3TextField.text = ""
        char4TextField.text = ""
        char5TextField.text = ""
        char6TextField.text = ""
        regionTextField.text = ""
        request.deleteCarRequest() { [weak self] deleteCarResponse in
            print("DELETED CAR: \(deleteCarResponse.toJSON())")
            guard deleteCarResponse.ok == true else { return }
            self?.char1TextField.placeholder = "X"
            self?.char2TextField.placeholder = "0"
            self?.char3TextField.placeholder = "0"
            self?.char4TextField.placeholder = "0"
            self?.char5TextField.placeholder = "X"
            self?.char6TextField.placeholder = "X"
            self?.regionTextField.placeholder = "000"
            self?.sendAlert(title: "Данные автомобиля удалены", message: "Введите новый номер")
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == textField.maxLength && textField.tag < 7 {
            let nextTextField = view.viewWithTag(textField.tag + 1) as! UITextField
            nextTextField.becomeFirstResponder()
        }
        if textField.text!.isEmpty && textField.tag > 1 {
            let nextTextField = view.viewWithTag(textField.tag - 1) as! UITextField
            nextTextField.becomeFirstResponder()
        }
    }
    
    //    MARK: Функции выбора карпика
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            carPicImageView.contentMode = .scaleAspectFill
            let carPic = pickedImage
            carPicImageView.image = carPic
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
//    Отрисовка существующего номера машины в текстфилдах
    func setPlaceholders() {
        var carNum = ""
        request.getCarDataRequest() { [weak self] car in
            if car.regNum != "" {
                self?.isCar = true
                carNum = car.regNum
                let carNumArray = Array(carNum)
                self?.char1TextField.placeholder = "\(carNumArray[0])"
                self?.char2TextField.placeholder = "\(carNumArray[1])"
                self?.char3TextField.placeholder = "\(carNumArray[2])"
                self?.char4TextField.placeholder = "\(carNumArray[3])"
                self?.char5TextField.placeholder = "\(carNumArray[4])"
                self?.char6TextField.placeholder = "\(carNumArray[5])"
                self?.regionTextField.placeholder = self?.service.createRegion(regNum: car.regNum)
            } else {
                self?.isCar = false
                carNum = "X000XX"
                let carNumArray = Array(carNum)
                self?.char1TextField.placeholder = "\(carNumArray[0])"
                self?.char2TextField.placeholder = "\(carNumArray[1])"
                self?.char3TextField.placeholder = "\(carNumArray[2])"
                self?.char4TextField.placeholder = "\(carNumArray[3])"
                self?.char5TextField.placeholder = "\(carNumArray[4])"
                self?.char6TextField.placeholder = "\(carNumArray[5])"
                self?.regionTextField.placeholder = "000"
            }
        }
    }
}
