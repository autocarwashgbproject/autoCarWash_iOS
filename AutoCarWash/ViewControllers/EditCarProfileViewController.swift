//
//  CarProfileViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 07/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import RealmSwift

class EditCarProfileViewController: UIViewController {
    
    @IBOutlet weak var carPicImageView: UIImageView!
    @IBOutlet weak var char1TextField: UITextField!
    @IBOutlet weak var char2TextField: UITextField!
    @IBOutlet weak var char3TextField: UITextField!
    @IBOutlet weak var char4TextField: UITextField!
    @IBOutlet weak var char5TextField: UITextField!
    @IBOutlet weak var char6TextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    let service = Service()
    var car: Car?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        car = service.loadCarFromRealm()
        
    }
    
    @IBAction func changeCarPic(_ sender: Any) {
    }
    
    @IBAction func deleteCarPic(_ sender: Any) {
    }
    
//    Сохранение изменений номера машны
    @IBAction func saveChanges(_ sender: Any) {
        guard char1TextField.text != "",
              char2TextField.text != "",
              char3TextField.text != "",
              char4TextField.text != "",
              char5TextField.text != "",
              char6TextField.text != "",
              regionTextField.text != "" else { return }
        let carNum = "\(char1TextField.text!)\(char2TextField.text!)\(char3TextField.text!)\(char4TextField.text!)\(char5TextField.text!)\(char6TextField.text!)\(regionTextField.text!)"
        let carNumSp = "\(char1TextField.text!) \(char2TextField.text!)\(char3TextField.text!)\(char4TextField.text!) \(char5TextField.text!)\(char6TextField.text!) \(regionTextField.text!)"
        let car = Car()
        car.regNum = carNum
        car.regNumSpaces = carNumSp
        car.isActive = true
        car.registrationDate = service.dateToUnixtime(date: Date())
        service.saveDataInRealmWithDeletingOld(object: car, objectType: Car.self)
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
//        Отправляем на сервер текущее время в параметре deleteDate
    }
    
    // MARK : - сделать перескакивающий курсор из одного окошка
//    @objc func textFieldDidChange() {
//
//        if char1TextField.text?.count == 1 {
//                char2TextField.becomeFirstResponder()
//        }
//    }
    
}
