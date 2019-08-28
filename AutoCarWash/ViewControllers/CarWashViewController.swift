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
    let service = Service()
    let reguest = AlamofireRequests()
    var user : User?
    var car : Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        Запрос на сервер о состоянии подписки, результат отобразить в subscribeStatusLabel
//        Если есть активная подписка, payButton.isHidden = true
        subscribeStatusLabel.isHidden = true        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        Загрузка данных пользователя из Realm
        user = service.loadUserFromRealm()
//        Если в Realm нет юзера, грyзим с сервера и сохраняем в Realm
        if user?.firstName == "" {
            loadUserFromServerAndSaveInRLM()
        }
        
//        Загрузка даных авто из Realm
        car = service.loadCarFromRealm()
//        Если в Realm нет авто, грузим с сервера и сохраняем в Realm
        if car?.regNum == "" {
            loadCarFromServerAndSaveInRLM()
        }
        
        userPicImageView.image = service.loadImageFromDiskWith(fileName: "userPic")
        
        guard let userToShow = user,
              let carToShow = car else { return }
        
        userNameLabel.text = "\(userToShow.firstName) \(userToShow.patronymic) \(userToShow.surname)"
        userTelNumberLabel.text = "\(userToShow.telNumString)"
        userEmailLabel.text = userToShow.email
        
        if carToShow.regNum == "" {
            carNumLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            carNumLabel.text = "x000xx"
            regionLabel.text = "000"
        } else {
            carNumLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            carNumLabel.text = carToShow.regNumSpaces
            regionLabel.text = carToShow.region
        }
        Session.session.carID = carToShow.carID
    }

    @IBAction func goToPayment(_ sender: Any) {
        performSegue(withIdentifier: paySegueID, sender: self)
    }
    
    func loadUserFromServerAndSaveInRLM() {
        reguest.getUserDataRequest() { [weak self] userResponse in
            let currentUser = User()
            currentUser.firstName = userResponse.firstName
            currentUser.surname = userResponse.surname
            currentUser.patronymic = userResponse.patronymic
            currentUser.telNum = userResponse.telNum
            currentUser.telNumString = self!.service.createTelNumString(String(userResponse.telNum))
            if userResponse.isBirthday == false {
                currentUser.birthdayString = ""
                currentUser.birthday = 0
            } else {
                currentUser.birthday = userResponse.birthday
                currentUser.birthdayString = self!.service.getDateFromUNIXTime(date: userResponse.birthday)
            }
            currentUser.email = userResponse.email
            currentUser.token = Session.session.token
            currentUser.userID = Session.session.userID
            self?.service.saveDataInRealmWithDeletingOld(object: currentUser, objectType: User.self)
            self?.userNameLabel.text = "\(currentUser.firstName) \(currentUser.patronymic) \(currentUser.surname)"
            self?.userTelNumberLabel.text = currentUser.telNumString
            self?.userEmailLabel.text = currentUser.email
        }
    }
    
    func loadCarFromServerAndSaveInRLM() {
        reguest.getCarDataRequest() { [weak self] carResponse in
            print("GET CAR REQUEST: \(carResponse.toJSON())")
            guard carResponse.ok == true else { return }
            Session.session.carID = carResponse.id
            let car = Car()
            car.carID = carResponse.id
            car.regNum = carResponse.regNum
            car.regNumSpaces = self!.service.createRegNumSpaces(regNum: carResponse.regNum)
            car.region = self!.service.createRegion(regNum: carResponse.regNum)
            self?.service.saveDataInRealmWithDeletingOld(object: car, objectType: Car.self)
            self?.carNumLabel.text = car.regNumSpaces
            self?.regionLabel.text = car.region
        }
    }
}
