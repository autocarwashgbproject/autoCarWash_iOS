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
    let service = Service()
    var userRLM: User?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        userRLM = service.loadUserFromRealm()
        
        guard let user = userRLM else { return }
        
        nameTextField.text = user.firstName
        surnameTextField.text = user.surname
        patronymicTextField.text = user.patronymic
        telNumTextField.text = user.telNum
        emailTextField.text = user.email
        birthdayTextField.text = user.birthday
    }
    
    @IBAction func changeUserPic(_ sender: Any) {
    }
    
    @IBAction func deleteUserPic(_ sender: Any) {
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        guard nameTextField.text != "",
              surnameTextField.text != "",
              telNumTextField.text != "",
              telNumTextField.text?.count == 10 else { sendAlert(title: "", message: "Пожалуйста, укажите имя, фамилию и номер телефона") ; return }
        do {
            let realm = try Realm()
            let user = realm.objects(User.self).first!
            try realm.write {
                user.setValue(nameTextField.text!, forKey: "firstName")
                user.setValue(surnameTextField.text!, forKey: "surname")
                user.setValue(patronymicTextField.text, forKey: "patronymic")
                user.setValue(telNumTextField.text!, forKey: "telNum")
                user.setValue(emailTextField.text, forKey: "email")
                user.setValue(birthdayTextField.text, forKey: "birthday")
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
//        Отправить юзера на экран авторизации так, чтобы он не попал в Navigation
        do {
            let realm = try Realm()
            realm.deleteAll()
        } catch {
            print(error)
        }
    }
    
    @IBAction func deleteAccuont(_ sender: Any) {
    }
    
    //    Алерт
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
