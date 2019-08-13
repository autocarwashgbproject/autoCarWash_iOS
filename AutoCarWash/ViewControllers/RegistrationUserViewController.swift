//
//  RegistrationVewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 02/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class RegistrationUserViewController: UIViewController {
    
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var telNumTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var IReadPolicyImageView: UIImageView!
    @IBOutlet weak var IAgreeImageView: UIImageView!
    let service = Service()
    let userDefaults = UserDefaults.standard
    let regCarSegueID = "toCarRegistr"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarImage()
        
        hideNavBarItem()
        
        telNumTextField.text = userDefaults.string(forKey: "telNum")
        
//        Распознавание тапа по вьюшкам "я согласем с условиями" "я прочитал политику"
        let IReadPolicy = UITapGestureRecognizer(target: self, action: #selector(readTap(recognizer:)))
        IReadPolicyImageView.isUserInteractionEnabled = true
        IReadPolicyImageView.addGestureRecognizer(IReadPolicy)
        
        let IAgreeTap = UITapGestureRecognizer(target: self, action: #selector(agreeTap(recognizer:)))
        IAgreeImageView.isUserInteractionEnabled = true
        IAgreeImageView.addGestureRecognizer(IAgreeTap)
        
    }
    
//    Тап по картинкам "я согласем с условиями" и "я прочитал политику"
    @objc func readTap(recognizer: UITapGestureRecognizer){
     changeState(imageView: IReadPolicyImageView)
    }
    
    @objc func agreeTap(recognizer: UITapGestureRecognizer){
        changeState(imageView: IAgreeImageView)
    }
    
//    Регистрация пользователя по нажатию кнопки "Зарегистрироваться"
    @IBAction func registration(_ sender: Any) {
        guard let surname = surnameTextField.text,
              let name = nameTextField.text,
              let patronymic = patronymicTextField.text,
              let telNum = Int(telNumTextField.text!),
              let email = emailTextField.text else { return }
        guard surname != "",
              name != "",
              telNum != 0 else { sendAlert(title: "Заполнены не все поля", message: "Пожалуйста, заполните все поля, помеченные звёздочкой"); return }
        guard IReadPolicyImageView.image == UIImage(named: "Rectangle 3_filled"),
              IAgreeImageView.image == UIImage(named: "Rectangle 3_filled")  else { sendAlert(title: "Заполнены не все поля", message: "Пожалуйста, подтвердите Ваше согласие с условиями пользования и политикой конфиденциальности"); return}
        let user = User()
        user.firstName = name
        user.surname = surname
        user.patronymic = patronymic
        user.telNum = telNum
        user.email = email
        user.isActive = true
        user.registrationDate = service.dateToUnixtime(date: Date())
        service.saveDataInRealmWithDeletingOld(object: user, objectType: User.self)
        performSegue(withIdentifier: regCarSegueID, sender: self)
//        Отправить данные пользователя на сервер
    }
    
//    Смена картинки с пустого квадрата на заполненный и наоборот
    func changeState(imageView: UIImageView){
        if imageView.image == UIImage(named: "Rectangle 3") {
            imageView.image = UIImage(named: "Rectangle 3_filled")
        } else {
            imageView.image = UIImage(named: "Rectangle 3")
        }
    }
}
