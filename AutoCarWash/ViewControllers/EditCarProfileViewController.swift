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
    var car: Car?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        carPicPicker.delegate = self
        
        car = service.loadCarFromRealm()
        
        carPicImageView.image = service.loadImageFromDiskWith(fileName: "carPic")
        oldCarPic = carPicImageView.image!
        
        char1TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char2TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char3TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char4TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char5TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char6TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let carPicTap = UITapGestureRecognizer(target: self, action: #selector(changeCarPic(recognizer:)))
        carPicImageView.isUserInteractionEnabled = true
        carPicImageView.addGestureRecognizer(carPicTap)
        
        setPlaseholders()
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
              regionTextField.text != "" else { if carPicImageView.image != oldCarPic {
                service.saveImage(imageName: "carPic", image: carPicImageView.image!)
                sendAlert(title: "Данные сохранены", message: "Фото автомобиля обновлено") };
                return
        }
        let carNum = "\(char1TextField.text!.uppercased())\(char2TextField.text!)\(char3TextField.text!)\(char4TextField.text!)\(char5TextField.text!.uppercased())\(char6TextField.text!.uppercased())\(regionTextField.text!)"
        if car?.regNum != "" {
            request.carSetDataRequest(regNum: carNum) { [weak self] carResponse in
                print("EDIT CAR: \(carResponse.toJSON())")
                guard carResponse.ok == true else { return }
                self?.saveCarData(carResponse)
            }
        } else {
            request.carRegistrationRequest(regNum: carNum) { carResponse in
                print("ADD NEW CAR: \(carResponse.toJSON())")
                guard carResponse.ok == true else { return }
                self.saveCarData(carResponse)
            }
        }
    }
    
//    Удаление машины
    @IBAction func deleteCar(_ sender: Any) {
        request.deleteCarRequest() { [weak self] deleteCarResponse in
            print("DELETED CAR: \(deleteCarResponse.toJSON())")
            guard deleteCarResponse.ok == true else { return }
            do {
                let realm = try Realm()
                let car = realm.objects(Car.self)
                realm.beginWrite()
                realm.delete(car)
                try realm.commitWrite()
            } catch {
                print(error)
            }
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
        if textField.text?.count == 1 {
            let nextTextField = view.viewWithTag(textField.tag + 1) as! UITextField
            nextTextField.becomeFirstResponder()
        }
    }
    
//    Функции выбора карпика
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
    
    func saveCarData(_ carResponse: CarResponse) {
        Session.session.carID = carResponse.id
        let car = Car()
        car.carID = carResponse.id
        car.regNum = carResponse.regNum
        car.regNumSpaces = service.createRegNumSpaces(regNum: carResponse.regNum)
        car.region = service.createRegion(regNum: carResponse.regNum)
        service.saveDataInRealmWithDeletingOld(object: car, objectType: Car.self)
        service.saveImage(imageName: "carPic", image: carPicImageView.image!)
        sendAlert(title: "Данные сохранены", message: "Номер автомобиля успешно обновлён")
    }
    
//    Отрисовка существующего номера машины в текстфилдах
    func setPlaseholders() {
        var carNum = ""
        if car?.regNum != "" {
            carNum = car!.regNum
            regionTextField.placeholder = car!.region
        } else {
            carNum = "X000XX"
            regionTextField.placeholder = "000"
        }
        let carNumArray = Array(carNum)
        char1TextField.placeholder = "\(carNumArray[0])"
        char2TextField.placeholder = "\(carNumArray[1])"
        char3TextField.placeholder = "\(carNumArray[2])"
        char4TextField.placeholder = "\(carNumArray[3])"
        char5TextField.placeholder = "\(carNumArray[4])"
        char6TextField.placeholder = "\(carNumArray[5])"
    }
}
