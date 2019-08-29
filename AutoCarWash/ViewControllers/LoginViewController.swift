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
    let userDefaults = UserDefaults.standard
    var phoneNumber = 0
    var code = 0
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
        guard saveTelNumber() else { return }
        if counterLabel.isHidden == true || counterLabel.text == "0 c" {
                repeatCodeLabel.isHidden = false
                counterLabel.isHidden = false
                countSec()
        } else {
            return
        }
        request.getSMS(telNum: phoneNumber){ [weak self] smsResponse in
            print("GET SMS REQUEST: \(smsResponse.toJSON())")
            if smsResponse.ok == true {
                self?.sendAlert(title: "Проверочный код", message: "\(smsResponse.code)")
                self?.codeTextField.text = "\(smsResponse.code)"
                self?.code = smsResponse.code
            } else {
                self?.sendAlert(title: "Не удалось отправить код", message: "Если номер телефона указан верно, значит проблема на нашей стороне. А значит, очень скоро мы всё починим!")
            }
        }
    }
    
//    Нажатие на кнопку "Далее", отправка на сервер телефона и проверочного кода
    @IBAction func login(_ sender: Any) {
        guard code != 0 else { return }
        request.clientAuthRequest(telNum: phoneNumber, code: code) { [weak self] authResponse in
            if authResponse.ok == true {
                Session.session.token = authResponse.token
                Session.session.userID = authResponse.userID
                Session.session.carID = authResponse.carID
                print("USER AUTH REQUEST: \(authResponse.toJSON())")
                self!.loginORregistr()
            } else {
                self?.sendAlert(title: "Не удалось авторизоваться.", message: "Если код указан верно, значит проблема на нашей стороне. А значит, очень скоро мы всё починим!")
            }
        }
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
    func saveTelNumber() -> Bool {
        guard let telNumText = telephoneNumberTextField.text,
            telNumText.count == telephoneNumberTextField.maxLength else { sendAlert(title: "Что-то не так", message: "Телефонный номер должен состоять из 10 цифр без пробелов"); return false }
        let userDefaults = UserDefaults.standard
        phoneNumber = Int(telNumText)!
        let telNumSpaces = service.createTelNumString(telNumText)
        userDefaults.set(phoneNumber, forKey: "telNum")
        userDefaults.set(telNumSpaces, forKey: "telNumSpaces")
        return true
    }
    
//    Выбор сегвея для перехода, если данные пользователя есть на сервере - идём на главную, иначе - на регистрацию
    func loginORregistr() {
        request.getUserDataRequest() { [weak self] user in
            print("GET USER REQUEST: \(user.toJSON())")
            if user.firstName != "" {
                self?.performSegue(withIdentifier: self!.loginSegueID, sender: self)
            } else {
                self?.performSegue(withIdentifier: self!.regSegueID, sender: self)
            }
        }
    }
}
