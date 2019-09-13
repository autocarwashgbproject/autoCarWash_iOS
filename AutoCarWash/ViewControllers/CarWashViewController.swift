//
//  CarWashViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 06/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class CarWashViewController: UIViewController {
    
    @IBOutlet weak var geoPositionLabel: UILabel!
    @IBOutlet weak var userProfileView: ProfileView!
    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTelNumberLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var subscribeStatusLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var carNumLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    let paySegueID = "toPaymentVCSegue"
    let userProfileSegueID = "toUserProfileSegue"
    let carProfileSegueID = "toCarProfileSegue"
    let authorisationSegueID = "toAuthSegue"
    var carNumber = ""
    let geoposition = "Великие Луки, пр-т Октябрьский, 9Б"
    var subscribe = false
    let service = Service()
    let reguest = AlamofireRequests()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoPositionLabel.text = geoposition
        
        payButton.isHidden = true
        subscribeStatusLabel.isHidden = true
        
        let toProfileTap = UITapGestureRecognizer(target: self, action: #selector(goToUserProfile(recognizer:)))
        userProfileView.isUserInteractionEnabled = true
        userProfileView.addGestureRecognizer(toProfileTap)
        
        let carNumTap = UITapGestureRecognizer(target: self, action: #selector(goToCarProfile(recognizer:)))
        carNumLabel.isUserInteractionEnabled = true
        carNumLabel.addGestureRecognizer(carNumTap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadUserAndShow()
        
        loadCarAndShow()

        userPicImageView.image = service.loadImageFromDiskWith(fileName: "userPic")
    }

//    Нажатие на кпонку "Оплатить"
    @IBAction func goToPayment(_ sender: Any) {
        guard carNumLabel.text != "x000xx" else { sendAlert(title: "Вам нужен автомобиль", message: "Пожалуйста, укажите номер автомобиля для оплаты абонемента"); return }
        performSegue(withIdentifier: paySegueID, sender: self)
    }
    
//    Переход на редактирование профиля по нажатию на вьюшку профиля
    @objc func goToUserProfile(recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: userProfileSegueID, sender: self)
    }
    
//    Переход на редактирование автомобиля по нажатию на номер
    @objc func goToCarProfile(recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: carProfileSegueID, sender: self)
    }
    
//    Загрузка пользователя с сервера и отображение данных, переход на авторизацию, если нет токена
    func loadUserAndShow() {
        reguest.getUserDataRequest() { [weak self] userResponse in
            if userResponse.detail == "Недопустимый токен." {
                self?.service.deleteDataFromRealm();
                self?.performSegue(withIdentifier: self!.authorisationSegueID, sender: self);
                return
            }
            print("GET USER: \(userResponse.ok ?? false) ID: \(userResponse.id ?? 0), Name: \(userResponse.name ?? "") \(userResponse.patronymic ?? "") \(userResponse.surname ?? "") Error: \(userResponse.error_code ?? 0) \(userResponse.description ?? "") \(userResponse.detail ?? "")")
            guard let ok = userResponse.ok else { return }
            guard ok else { self?.sendAlert(title: "Не удаётся загрузить данные с сервера", message: "Возможно, отсутствует соединение с Интернетом или соединениe слишком слабое"); return }
            if userResponse.cars_id != nil {
                Session.session.carIDs = userResponse.cars_id!
                Session.session.carID = userResponse.cars_id![0]
                self?.loadCarAndShow()
            }
            User.user.fullName = "\(userResponse.name ?? "") \(userResponse.patronymic ?? "") \(userResponse.surname ?? "")"
            User.user.shortName = "\(userResponse.name ?? "") \(userResponse.surname ?? "")"
            let phoneNumber = "\(userResponse.phone ?? 0000000000)"
            User.user.telNumber = "+7-\(self!.service.createTelNumString(phoneNumber))"
            User.user.email = userResponse.email ?? ""
            self?.userNameLabel.text = User.user.fullName
            self?.userTelNumberLabel.text = User.user.telNumber
            self?.userEmailLabel.text = User.user.email
            guard let isBirthday = userResponse.is_birthday else { return }
            if isBirthday {
                User.user.birthday = self!.service.getDateFromUNIXTime(date: userResponse.birthday!)
            }
        }
    }
    
//        Загрузка авто с сервера и отображение данных
    func loadCarAndShow() {
        reguest.getCarDataRequest() { [weak self] carResponse in
            print("GET CAR: \(carResponse.ok ?? false) ID: \(carResponse.id ?? 0) Regnum: \(carResponse.reg_num ?? "")")
            guard let regNum = carResponse.reg_num else { return }
            if regNum == "" {
                self?.carNumLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                self?.regionLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                self?.carNumLabel.text = "x000xx"
                self?.regionLabel.text = "000"
            } else {
                Car.car.regNum = self!.service.createRegNumSpaces(regNum: regNum)
                Car.car.region = self!.service.createRegion(regNum: regNum)
                self?.carNumLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                self?.regionLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                self?.carNumLabel.text = Car.car.regNum
                self?.regionLabel.text = Car.car.region
            }
            guard let isSubscribe = carResponse.is_subscribe else { return }
            if isSubscribe {
                self?.payButton.isHidden = true
                self?.subscribeStatusLabel.isHidden = false
                let endDate = self!.service.getDateFromUNIXTime(date: carResponse.subscription_date_validation!)
                self?.subscribeStatusLabel.text = "Абонемент оплачен до \(endDate)"
            } else {
                self?.payButton.isHidden = false
                self?.subscribeStatusLabel.isHidden = true
            }
        }
    }
}
