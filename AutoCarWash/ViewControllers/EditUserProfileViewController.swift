//
//  EditUserProfileViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 07/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import RealmSwift

class EditUserProfileViewController: UIViewController {
    
    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var telNumTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    let birthdayPicker = UIDatePicker()
    let service = Service()
    var userRLM: User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDatePicker()
        
        userRLM = service.loadUserFromRealm()
        
        guard let user = userRLM else { return }
        
        nameTextField.text = user.firstName
        surnameTextField.text = user.surname
        patronymicTextField.text = user.patronymic
        telNumTextField.text = user.telNum
        emailTextField.text = user.email
        birthdayTextField.text = user.birthdayString
    }
    
    func addDatePicker(){
        birthdayPicker.datePickerMode = .date
        birthdayPicker.locale = Locale(identifier: "RU")
        birthdayTextField.inputView = birthdayPicker
        birthdayPicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func dateChanged(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        birthdayTextField.text = formatter.string(from: birthdayPicker.date)
    }
    
    @IBAction func changeUserPic(_ sender: Any) {
    }
    
    @IBAction func deleteUserPic(_ sender: Any) {
    }
    
//    Сохранение изменений данных пользователя
    @IBAction func saveChanges(_ sender: Any) {
        var birthDayUNIX = 0
        guard nameTextField.text != "",
              surnameTextField.text != "",
              telNumTextField.text != "",
            telNumTextField.text?.count == 10 else { sendAlert(title: "", message: "Пожалуйста, обязательно укажите имя, фамилию и номер телефона") ; return }
        if birthdayTextField.text != "" {
            let dateOfBirth = service.stringToDate(dateString: birthdayTextField.text!)
            birthDayUNIX = service.dateToUnixtime(date: dateOfBirth)
        }
        do {
            let realm = try Realm()
            let user = realm.objects(User.self).first!
            try realm.write {
                user.setValue(nameTextField.text, forKey: "firstName")
                user.setValue(surnameTextField.text, forKey: "surname")
                user.setValue(patronymicTextField.text, forKey: "patronymic")
                user.setValue(telNumTextField.text, forKey: "telNum")
                user.setValue(emailTextField.text, forKey: "email")
                user.setValue(birthDayUNIX, forKey: "birthday")
                user.setValue(birthdayTextField.text, forKey: "birthdayString")
            }
        } catch {
            print(error)
        }
        sendAlert(title: "", message: "Ваши данные обновлены")
//        Отправить на сервер новые данные
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print(error)
        }
        performSegue(withIdentifier: "logOutSegue", sender: self)
    }
    
    @IBAction func deleteAccuont(_ sender: Any) {
        deleteAlert(title: "Удалить аккаунт?", message: "Вы уверены, что хотите удалить аккаунт? Данные будут удалены безвозвратно")
//        Отправить на удалённый сервер параметр is+active = false, текущее время как параметр delete_date
        
    }
    
    func deleteAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let actionYes = UIAlertAction(title: "Да", style: .default, handler: { (actionYes) in
            self.deleteAccount()
            self.performSegue(withIdentifier: "logOutSegue", sender: self)
        })
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteAccount() {
        let deleteDate = Date()
        service.dateToUnixtime(date: deleteDate)
//        Отправить на сервер дату удаления
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
