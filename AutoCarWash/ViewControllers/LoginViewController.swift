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
    var phoneNumber = ""
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
        if counterLabel.isHidden || counterLabel.text == "0 c" {
            repeatCodeLabel.isHidden = false
            counterLabel.isHidden = false
            countSec()
        } else {
            return
        }
        request.getSMS(telNum: phoneNumber){ [weak self] smsResponse in
            print("GET SMS REQUEST: \(smsResponse.ok ?? false), Code: \(smsResponse.sms_for_tests ?? 0), Phone: \(smsResponse.phone ?? ""), Error: \(smsResponse.error_code ?? 0), Description: \(smsResponse.description ?? "No error"), Detail: \(smsResponse.detail ?? "No detail")")
            guard smsResponse.ok == true else {
                self?.sendAlert(title: "Не удалось отправить код", message: "Если номер телефона указан верно, значит проблема на нашей стороне. А значит, очень скоро мы всё починим!");
                return }
            self?.sendAlert(title: "Проверочный код", message: "\(smsResponse.sms_for_tests!)")
            self?.codeTextField.text = "\(smsResponse.sms_for_tests!)"
            self?.code = smsResponse.sms_for_tests!
        }
    }
    
//    Нажатие на кнопку "Далее", отправка на сервер телефона и проверочного кода
    @IBAction func login(_ sender: Any) {
        guard code != 0 else { return }
        request.clientAuthRequest(telNum: phoneNumber, code: code) { [weak self] authResponse in
            guard authResponse.ok == true  else {
                self?.sendAlert(title: "Не удалось авторизоваться.", message: "Если код указан верно, значит проблема на нашей стороне. А значит, очень скоро мы всё починим!");
                return
            }
            let sessionInfo = SessionInfo()
            sessionInfo.userID = authResponse.id!
            sessionInfo.token = authResponse.token!
            if authResponse.cars_id != nil {
                if !authResponse.cars_id!.isEmpty {
                    Session.session.carIDs = authResponse.cars_id!
                    sessionInfo.carID = authResponse.cars_id![0]
                }
            }
            self?.service.saveDataInRealm(object: sessionInfo, objectType: SessionInfo.self)
            Session.session.token = sessionInfo.token
            Session.session.userID = sessionInfo.userID
            Session.session.carID = sessionInfo.carID
            print("USER AUTH REQUEST: \(authResponse.ok ?? false), Token: \(authResponse.token ?? "No token"), UserID: \(authResponse.id ?? 0), CarIDs: \(authResponse.cars_id ?? [0]), IsRegistered: \(authResponse.is_registered ?? false), Telephone: \(authResponse.phone ?? ""), Error: \(authResponse.error_code ?? 0), \(authResponse.description ?? "No error"), \(authResponse.detail ?? "")")
            self!.loginORregistr()
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
              telNumText.count == telephoneNumberTextField.maxLength else {
                sendAlert(title: "Что-то не так", message: "Телефонный номер должен состоять из 10 цифр без пробелов");
                return false
        }
        let userDefaults = UserDefaults.standard
        let telNumSpaces = service.createTelNumString(telNumText)
        phoneNumber = telNumText
        userDefaults.set(phoneNumber, forKey: "telNum")
        userDefaults.set(telNumSpaces, forKey: "telNumSpaces")
        return true
    }
    
//    Выбор сегвея для перехода, если данные пользователя есть на сервере - идём на главную, иначе - на регистрацию
    func loginORregistr() {
        request.getUserDataRequest() { [weak self] userResponse in
            print("GET USER REQUEST: \(userResponse.ok ?? false) ID: \(String(describing: userResponse.id)), Name: \(String(describing: userResponse.name)) \(String(describing: userResponse.patronymic)) \(String(describing: userResponse.surname)), Cars: \( userResponse.cars_id ?? [0]), Error: \(userResponse.error_code ?? 0) \(userResponse.description ?? "") \(userResponse.description ?? "")")
            if userResponse.name != nil {
                self?.performSegue(withIdentifier: self!.loginSegueID, sender: self)
            } else {
                self?.performSegue(withIdentifier: self!.regSegueID, sender: self)
            }
        }
    }
}
