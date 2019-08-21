//
//  LoginViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 02/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var telephoneNumberTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var repeatCodeLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    let request = AlamofireRequests()
    let service = Service()
    let currentSession = Session.session
    let userDefaults = UserDefaults.standard
    var phoneNumber = 0
    let loginSegueID = "logInSegue"
    let regSegueID = "registrationSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repeatCodeLabel.isHidden = true
        counterLabel.isHidden = true
        
        setNavBarImage()
        
        service.saveImage(imageName: "userPic", image: #imageLiteral(resourceName: "circle_user"))
        service.saveImage(imageName: "carPic", image: #imageLiteral(resourceName: "circle_car"))
        
    }
    
//    Отправка пользователю смс с кодом
    @IBAction func getSMSCode(_ sender: Any) {
        saveTelNumber()
        if counterLabel.isHidden == true || counterLabel.text == "0 c" {
                repeatCodeLabel.isHidden = false
                counterLabel.isHidden = false
                countSec()
        } else {
            return
        }
//        Запрос на сервер для получения смс-кода "Регистрация номера телефона", если в ответе ок = false, алерт
    }
    
    @IBAction func login(_ sender: Any) {
//        guard let smsCodeStr = codeTextField.text else { return }
//        let smsCode = Int(smsCodeStr)!
//        request.clientAuthRequest(telNum: phoneNumber, smsCode: smsCode) { [weak self] authResponse in
//            if authResponse.ok == true {
//                self?.currentSession.token = authResponse.token
//                self?.currentSession.userID = authResponse.userID
//                if authResponse.isRegistr == true {
//                    self?.performSegue(withIdentifier: self!.loginSegueID, sender: self)
//                }
//                self?.performSegue(withIdentifier: self!.regSegueID, sender: self)
//            } else {
//                self?.sendAlert(title: "Что-то пошло не так", message: "Не получается авторизоваться")
//            }
//        }
        performSegue(withIdentifier: regSegueID, sender: self)
    
    }
    
//    Счётчик 60 секунд до возможности отправки повторного смс
    func countSec() {
        var sec = 60
        counterLabel.text = "\(sec) c"
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard sec > 0 else { return }
            sec -= 1
            self.counterLabel.text = "\(sec) c"
        }
    }
//    Сохранение номера телефона в UserDefaults
    func saveTelNumber() {
        guard let telNumText = telephoneNumberTextField.text,
            telNumText.count == telephoneNumberTextField.maxLength else { sendAlert(title: "Что-то не так", message: "Проверьте правильность введённого номера"); return }
        let userDefaults = UserDefaults.standard
        phoneNumber = Int(telNumText)!
        let telNumSpaces = service.createTelNumString(telNumText)
        userDefaults.set(phoneNumber, forKey: "telNum")
        userDefaults.set(telNumSpaces, forKey: "telNumSpaces")
    }
}
