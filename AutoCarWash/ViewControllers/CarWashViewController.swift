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
    let profileSegueID = "toUserProfileSegue"
    let authorisationSegueID = "toAuthSegue"
    let service = Service()
    let reguest = AlamofireRequests()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payButton.isHidden = true
        subscribeStatusLabel.isHidden = true
        
        let toProfileTap = UITapGestureRecognizer(target: self, action: #selector(goToUserProfile(recognizer:)))
        userProfileView.isUserInteractionEnabled = true
        userProfileView.addGestureRecognizer(toProfileTap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadUserAndShow()
        
        loadCarAndShow()

        userPicImageView.image = service.loadImageFromDiskWith(fileName: "userPic")
    }

//    Нажатие на кпонку "Оплатить"
    @IBAction func goToPayment(_ sender: Any) {
        performSegue(withIdentifier: paySegueID, sender: self)
    }
    
//    Переход на редактирование профиля по нажатию на вьюшку профиля
    @objc func goToUserProfile(recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: profileSegueID, sender: self)
    }
    
//        Загрузка пользователя с сервера и отображение данных, переход на авторизацию, если нет токена
    func loadUserAndShow() {
        reguest.getUserDataRequest() { [weak self] userResponse in
            print("GET USER: \(userResponse.toJSON())")
            if userResponse.detail == "Недопустимый токен." {
                self?.service.deleteDataFromRealm();
                self?.performSegue(withIdentifier: self!.authorisationSegueID, sender: self);
                return
            }
            if !userResponse.cars.isEmpty {
                Session.session.carIDs = userResponse.cars
                Session.session.carID = userResponse.cars[0]
                self?.loadCarAndShow()
            }
            User.user.fullName = "\(userResponse.firstName) \(userResponse.patronymic) \(userResponse.surname)"
            User.user.shortName = "\(userResponse.firstName) \(userResponse.surname)"
            User.user.telNumber = "+7-\(self!.service.createTelNumString(userResponse.telNum))"
            User.user.email = userResponse.email
            if userResponse.isBirthday {
                User.user.birthday = self!.service.getDateFromUNIXTime(date: userResponse.birthday)
            }
            self?.userNameLabel.text = User.user.fullName
            self?.userTelNumberLabel.text = User.user.telNumber
            self?.userEmailLabel.text = User.user.email
        }
    }
    
//        Загрузка авто с сервера и отображение данных
    func loadCarAndShow() {
        reguest.getCarDataRequest() { [weak self] car in
            print("GET CAR: \(car.toJSON())")
            if car.regNum == "" {
                self?.carNumLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                self?.regionLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                self?.carNumLabel.text = "x000xx"
                self?.regionLabel.text = "000"
            } else {
                Car.car.regNum = self!.service.createRegNumSpaces(regNum: car.regNum)
                Car.car.region = self!.service.createRegion(regNum: car.regNum)
                self?.carNumLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                self?.regionLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                self?.carNumLabel.text = Car.car.regNum
                self?.regionLabel.text = Car.car.region
            }
            if car.isSubscribe {
                self?.payButton.isHidden = true
                self?.subscribeStatusLabel.isHidden = false
                let endDate = self!.service.getDateFromUNIXTime(date: car.endDate)
                self?.subscribeStatusLabel.text = "Абонемент оплачен до \(endDate)"
            } else {
                self?.payButton.isHidden = false
                self?.subscribeStatusLabel.isHidden = true
            }
        }
    }
}
