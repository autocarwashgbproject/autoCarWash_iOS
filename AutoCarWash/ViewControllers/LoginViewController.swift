//
//  LoginViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 02/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var telephoneNumberTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getSMSCode(_ sender: Any) {
//        Запрос на сервер для получения смс-кода
    }
    
    @IBAction func login(_ sender: Any) {
//        Сравнить введённый код с присланным в смс
//        получить данные пользователя и автомобиля из удалённой базы данных, записать в Realm для отображения
    }
    
}
