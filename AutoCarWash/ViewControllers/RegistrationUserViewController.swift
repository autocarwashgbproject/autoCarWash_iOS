//
//  RegistrationVewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 02/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationUserViewController: UIViewController {
    
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var telNumLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var IAgreeImageView: UIImageView!
    let service = Service()
    let userDefaults = UserDefaults.standard
    let regCarSegueID = "toCarRegistr"
    var userTelNum = 0
    var userTelNumSp = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarImage()
        
        hideNavBarItem()
        
        userTelNum = userDefaults.integer(forKey: "telNum")
        userTelNumSp = userDefaults.string(forKey: "telNumSpaces")!
        telNumLabel.text = userTelNumSp
        
//        Распознавание тапа по вьюшке "я согласем с условиями"
        let IAgreeTap = UITapGestureRecognizer(target: self, action: #selector(agreeTap(recognizer:)))
        IAgreeImageView.isUserInteractionEnabled = true
        IAgreeImageView.addGestureRecognizer(IAgreeTap)
        
    }
    
//    Тап по картинкам "я согласем с условиями"
    @objc func agreeTap(recognizer: UITapGestureRecognizer){
        changeState(imageView: IAgreeImageView)
    }
    
//    Регистрация пользователя по нажатию кнопки "Зарегистрироваться"
    @IBAction func registration(_ sender: Any) {
        guard let surname = surnameTextField.text,
              let name = nameTextField.text,
              let patronymic = patronymicTextField.text,
              let telNum = telNumLabel.text,
              let email = emailTextField.text else { return }
        guard surname != "",
              name != "",
              telNum != "" else { sendAlert(title: "Заполнены не все поля", message: "Пожалуйста, заполните все поля, помеченные звёздочкой"); return }
        guard IAgreeImageView.image == UIImage(named: "Rectangle 3_filled")  else { sendAlert(title: "Заполнены не все поля", message: "Пожалуйста, подтвердите Ваше согласие с условиями пользования"); return}
        let user = User()
        user.firstName = name
        user.surname = surname
        user.patronymic = patronymic
        user.telNum = userTelNum
        user.telNumString = userTelNumSp
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
