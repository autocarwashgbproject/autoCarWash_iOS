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
    var isCar : Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Запрос на сервер о состоянии подписки
        
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
    
//    MARK: - Изменение фото машины
//    - по нажатию на аватарку
    @objc func changeCarPic(recognizer: UITapGestureRecognizer) {
        pickPhotoFromLibrary(imagePicker: carPicPicker)
    }
    
//    - по нажатию на кнопу "Изменить фото"
    @IBAction func changeCarPic(_ sender: UIButton) {
        pickPhotoFromLibrary(imagePicker: carPicPicker)
    }
    
//    Нажатие на кнопку "Удалить фото"
    @IBAction func deleteCarPic(_ sender: Any) {
        carPicDelete()
    }
    
//    Удаление фото машины
    func carPicDelete() {
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
                sendAlert(title: "Готово", message: "Фото автомобиля обновлено") };
                return
        }
//        guard нет_абонемента else { sendAlert(title: "Нельзя изменить номер автомобиля", message: "У Вас оплачен абонемент на пользование автомойкой. Пока подписка активна, номер автомобиля измeнить невозможно"); return}
        let carNum = "\(char1TextField.text!.uppercased())\(char2TextField.text!)\(char3TextField.text!)\(char4TextField.text!)\(char5TextField.text!.uppercased())\(char6TextField.text!.uppercased())\(regionTextField.text!)"
        if isCar {
            request.carSetDataRequest(regNum: carNum) { [weak self] carResponse in
                print("EDIT CAR: \(carResponse.toJSON())")
                guard carResponse.ok else { return }
                self?.service.saveImage(imageName: "carPic", image: self!.carPicImageView.image!)
                self?.sendAlert(title: "Готово", message: "Данные автомобиля обновлены")
            }
        } else {
            request.carRegistrationRequest(regNum: carNum) { [weak self] carResponse in
                print("ADD NEW CAR: \(carResponse.toJSON())")
                guard carResponse.ok else { return }
                self?.isCar = true
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
                self?.sendAlert(title: "Готово", message: "Данные автомобиля обновлены")
            }
        }
    }
    
    //    Нажатие на кнопку "Удалить автомобиль"
    @IBAction func deleteCar(_ sender: Any) {
        deleteAlert()
    }
    
//    Перестановка курсора
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
    
    //    MARK: - Функции выбора аватарки машины
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
    
//    Отрисовка существующего номера машины в плэйсхолдерах тестовых полей
    func setPlaceholders() {
        var carNum = ""
        request.getCarDataRequest() { [weak self] car in
            if car.regNum != "" {
                self?.isCar = true
                carNum = car.regNum
                self?.separateRegNumAndShow(carNum)
                self?.regionTextField.placeholder = self?.service.createRegion(regNum: car.regNum)
            } else {
                self?.isCar = false
                carNum = "X000XX"
                self?.separateRegNumAndShow(carNum)
                self?.regionTextField.placeholder = "000"
            }
        }
    }
    
//    Разделение и отображение номера
    func separateRegNumAndShow(_ carNum: String) {
        let carNumArray = Array(carNum)
        char1TextField.placeholder = "\(carNumArray[0])"
        char2TextField.placeholder = "\(carNumArray[1])"
        char3TextField.placeholder = "\(carNumArray[2])"
        char4TextField.placeholder = "\(carNumArray[3])"
        char5TextField.placeholder = "\(carNumArray[4])"
        char6TextField.placeholder = "\(carNumArray[5])"
    }
    
//    Алерт с предупреждением об удалении автомобиля
    func deleteAlert() {
        let alert = UIAlertController(title: "Удалить автомобиль?", message: "", preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let actionYes = UIAlertAction(title: "Да", style: .default, handler: { actionYes in
            self.char1TextField.text = nil
            self.char2TextField.text = nil
            self.char3TextField.text = nil
            self.char4TextField.text = nil
            self.char5TextField.text = nil
            self.char6TextField.text = nil
            self.regionTextField.text = nil
            self.request.deleteCarRequest() { [weak self] deleteCarResponse in
                print("DELETED CAR: \(deleteCarResponse.toJSON())")
                guard deleteCarResponse.ok else { return }
                self?.separateRegNumAndShow("X000XX")
                self?.regionTextField.placeholder = "000"
                self?.carPicDelete()
                self?.isCar = false
                self?.sendAlert(title: "Данные автомобиля удалены", message: "Введите новый номер")
            }
        })
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true, completion: nil)
    }
}
