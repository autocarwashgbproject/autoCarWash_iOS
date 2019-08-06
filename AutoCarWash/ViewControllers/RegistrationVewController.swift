//
//  RegistrationVewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 02/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class RegistrationVewController: UIViewController {
    
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var telNumTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var IReadPolicyImageView: UIImageView!
    @IBOutlet weak var IAgreeImageView: UIImageView!
    @IBOutlet weak var enterSMSCodeTextField: UITextField!
    @IBOutlet weak var line8ImageView: UIImageView!
    @IBOutlet weak var enterButton: UIButton!
    let service = Service()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterButton.isHidden = true
        enterSMSCodeTextField.isHidden = true
        line8ImageView.isHidden = true
        
        let IReadPolicy = UITapGestureRecognizer(target: self, action: #selector(readTap(recognizer:)))
        IReadPolicyImageView.isUserInteractionEnabled = true
        IReadPolicyImageView.addGestureRecognizer(IReadPolicy)
        
        let IAgreeTap = UITapGestureRecognizer(target: self, action: #selector(agreeTap(recognizer:)))
        IAgreeImageView.isUserInteractionEnabled = true
        IAgreeImageView.addGestureRecognizer(IAgreeTap)
        
    }
    
    @objc func readTap(recognizer: UITapGestureRecognizer){
     changeState(imageView: IReadPolicyImageView)
    }
    
    @objc func agreeTap(recognizer: UITapGestureRecognizer){
        changeState(imageView: IAgreeImageView)
    }
    
    
    @IBAction func registration(_ sender: Any) {
        guard let surname = surnameTextField.text,
              let name = nameTextField.text,
              let patronymic = patronymicTextField.text,
              let telNum = telNumTextField.text,
              let email = emailTextField.text,
              let password1 = password1TextField.text,
              let password2 = password2TextField.text else { return }
        guard surname != "",
              name != "",
              telNum != "",
              password1 != "",
              password2 != "" else { sendAlert(title: "Заполнены не все поля", message: "Пожалуйста, заполните все поля, помеченные звёздочкой"); return }
        guard password1 == password2 else { sendAlert(title: "Пароль не совпадет", message: "Пожалуйста, проверьте правильность введённого пвроля"); return }
        guard IReadPolicyImageView.image == UIImage(named: "Rectangle 3_filled"),
              IAgreeImageView.image == UIImage(named: "Rectangle 3_filled")  else { sendAlert(title: "Заполнены не все поля", message: "Пожалуйста, подтвердите Ваше согласие с условиями использования и политикой конфиденциальности"); return}
        sendAlert(title: "Осталось совсем чуть-чуть", message: "На Ваш телефон отправлен код авторизации, введите его в поле ниже. Если код не доставлен, проверьте правильность введённого номера и снова нажмите 'Зарегистрироваться'.")
        enterSMSCodeTextField.isHidden = false
        line8ImageView.isHidden = false
        enterButton.isHidden = false
        let user = User()
        user.firstName = name
        user.surname = surname
        user.patronymic = patronymic
        user.telNum = telNum
        user.email = email
        user.isActive = true
        user.registrationDate = service.dsateToUnixtime(date: Date())
        print("Created user with name: \(user.firstName), surname: \(user.surname), patronymic: \(user.patronymic), telephone: \(user.telNum), email: \(user.email)")        
        service.saveDataInRealmWithDeletingOld(object: user, objectType: User.self)
    }
 
    @IBAction func enter(_ sender: Any) {
        guard let code = enterSMSCodeTextField.text else { return }
        
    }
    
    
    func changeState(imageView: UIImageView){
        if imageView.image == UIImage(named: "Rectangle 3") {
            imageView.image = UIImage(named: "Rectangle 3_filled")
        } else {
            imageView.image = UIImage(named: "Rectangle 3")
        }
    }
    
    func sendAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
