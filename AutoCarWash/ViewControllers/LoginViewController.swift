//
//  LoginViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 02/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var telephoneNumberTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var repeatCodeLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    let service = Service()
    let loginSegueID = "logInSegue"
    let regSegueID = "registrationSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repeatCodeLabel.isHidden = true
        counterLabel.isHidden = true
        
        setNavBarImage()
    }
    
    @IBAction func getSMSCode(_ sender: Any) {
        repeatCodeLabel.isHidden = false
        counterLabel.isHidden = false
        countSec()
        saveTelNumber()
//        Запрос на сервер для получения смс-кода "Регистрация номера телефона"
    }
    
    @IBAction func login(_ sender: Any) {
//        Отправить на сервер введённый код, получить ответ, если ок - идём дальше, если нет - алерт
//        Отправить на сервер запрос о существовании пользователя с таким номером
//        Если такой пользователь уже существует -
//        guard codeTextField.text == "5555"  else { return } - сравниваем с  кодом из смс
//            performSegue(withIdentifier: loginSegue, sender: self)
//        Если пользователя нет -
        guard codeTextField.text == "5555"  else { return }
            performSegue(withIdentifier: regSegueID, sender: self)
    }
    
    func countSec() {
        var sec = 60
        counterLabel.text = "\(sec) с"
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard sec > 0 else { return }
            sec -= 1
            self.counterLabel.text = "\(sec) с"
        }
    }
    
    func saveTelNumber() {
        guard let telNumText = telephoneNumberTextField.text else { return }
        let userDefaults = UserDefaults.standard
        let telNum = Int(telNumText)
        let telNumSpaces = service.createTelNumString(telNumText)
        userDefaults.set(telNum, forKey: "telNum")
        userDefaults.set(telNumSpaces, forKey: "telNumSpaces")
    }
}
