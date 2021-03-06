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
    var isSubscribe = false
    var carNum = ""

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
            regionTextField.text != "" else {
                if carPicImageView.image != oldCarPic {
                    service.saveImage(imageName: "carPic", image: carPicImageView.image!)
                    sendAlert(title: "Готово", message: "Фото автомобиля обновлено") };
                return
        }
        guard !isSubscribe else { sendAlert(title: "Невозможно изменить номер автомобиля", message: "У Вас есть оплаченный абонемент на пользование автомойкой для автомобиля c номером \(Car.car.regNum) \(Car.car.region) RUS. Пока подписка активна, номер автомобиля измeнить нельзя");
            cleanTextFields();
            separateRegNumAndShow(carNum);
            return }
        let carNum = "\(char1TextField.text!.uppercased())\(char2TextField.text!)\(char3TextField.text!)\(char4TextField.text!)\(char5TextField.text!.uppercased())\(char6TextField.text!.uppercased())\(regionTextField.text!)"
        if isCar {
            request.carSetDataRequest(regNum: carNum) { [weak self] carResponse in
                print("EDIT CAR: \(carResponse.ok ?? false) ID: \(carResponse.id ?? 0), New number: \(carResponse.reg_num ?? "No reg_num") Error: \(carResponse.error_code ?? 0), \(carResponse.description ?? ""), \(carResponse.detail ?? "")")
                guard let ok = carResponse.ok else { self?.sendAlert(title: "Не удаётся сохранить изменения", message: "Возможно, отсутствует соединение с интернетом, попробуйте позднее"); return }
                guard ok else { return }
                Car.car.regNum = self!.service.createRegNumSpaces(regNum: carResponse.reg_num!)
                Car.car.region = self!.service.createRegion(regNum: carResponse.reg_num!)
                self?.service.saveImage(imageName: "carPic", image: self!.carPicImageView.image!)
                self?.sendAlert(title: "Готово", message: "Данные автомобиля обновлены")
            }
        } else {
            request.carRegistrationRequest(regNum: carNum) { [weak self] carResponse in
                print("ADD NEW CAR: \(carResponse.ok ?? false) ID: \(carResponse.id ?? 0) Regnum: \(carResponse.reg_num ?? "") Error: \(carResponse.error_code ?? 0), \(carResponse.description ?? ""), \(carResponse.detail ?? "")")
                guard carResponse.ok == true else { self?.sendAlert(title: "Не удаётся сохранить изменения", message: "Возможно, отсутствует соединение с интернетом, попробуйте позднее"); return }
                self?.isCar = true
                Session.session.carID = carResponse.id!
                Car.car.regNum = self!.service.createRegNumSpaces(regNum: carResponse.reg_num!)
                Car.car.region = self!.service.createRegion(regNum: carResponse.reg_num!)
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
        guard isCar else { return }
        guard !isSubscribe else { sendAlert(title: "Невозможно удалить автомобиль", message: "У Вас есть оплаченный абонемент на пользование автомойкой для автомобиля c номером \(Car.car.regNum) \(Car.car.region) RUS. Пока подписка активна, удалить автомобиль нельзя"); return}
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
        request.getCarDataRequest() { [weak self] carResponse in
            if carResponse.ok == true {
                self?.isCar = true
                self?.isSubscribe = carResponse.is_subscribe!
                self?.carNum = carResponse.reg_num!
                self?.separateRegNumAndShow(self!.carNum)
                self?.regionTextField.placeholder = self?.service.createRegion(regNum: self!.carNum)
            } else {
                self?.isCar = false
                self?.isSubscribe = false
                self?.carNum = "X000XX"
                self?.separateRegNumAndShow(self!.carNum)
                self?.regionTextField.placeholder = "000"
            }
        }
    }
    
//    Обнуление текста текстфилдов
    func cleanTextFields() {
        char1TextField.text = nil
        char2TextField.text = nil
        char3TextField.text = nil
        char4TextField.text = nil
        char5TextField.text = nil
        char6TextField.text = nil
        regionTextField.text = nil
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
            self.request.deleteCarRequest() { [weak self] deleteCarResponse in
                print("DELETED CAR: \(deleteCarResponse.ok ?? false) ID: \(deleteCarResponse.id ?? 0), \(deleteCarResponse.description ?? "")")
                if deleteCarResponse.ok == true {
                    self?.cleanTextFields()
                    self?.separateRegNumAndShow("X000XX")
                    self?.regionTextField.placeholder = "000"
                    self?.carPicDelete()
                    self?.isCar = false
                    self?.isSubscribe = false
                    Car.car.regNum = ""
                    Car.car.region = ""
                    self?.sendAlert(title: "Данные автомобиля удалены", message: "Введите новый номер")
                } else {
                    self?.sendAlert(title: "Не удалось удалить автомобиль", message: "Возможно отсутствует интернет-соединение")
                }
            }
        })
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true, completion: nil)
    }
}
