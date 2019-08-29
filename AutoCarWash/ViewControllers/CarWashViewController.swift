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
    let service = Service()
    let reguest = AlamofireRequests()
    var user : User?
    var car : Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        Запрос на сервер о состоянии подписки, результат отобразить в subscribeStatusLabel
//        Если есть активная подписка, payButton.isHidden = true
        subscribeStatusLabel.isHidden = true
        
        let toProfileTap = UITapGestureRecognizer(target: self, action: #selector(goToUserProfile(recognizer:)))
        userProfileView.isUserInteractionEnabled = true
        userProfileView.addGestureRecognizer(toProfileTap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        Загрузка пользователя из Realm или с сервера и отображение данныъ
        service.loadUserFromRealm() { user in
            if user.firstName == "" {
                loadUserFromServerAndSaveInRLM()
            } else {
                userNameLabel.text = "\(user.firstName) \(user.patronymic) \(user.surname)"
                userTelNumberLabel.text = "\(user.telNumString)"
                userEmailLabel.text = user.email
            }
        }
        
//        Загрузка авто из Realm или с сервера и отображение данных
        service.loadCarFromRealm() { car in
            if car.regNum == "" {
                self.carNumLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                self.regionLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                self.carNumLabel.text = "x000xx"
                self.regionLabel.text = "000"
                self.loadCarFromServerAndSaveInRLM()
            } else {
                self.carNumLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                self.regionLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                self.carNumLabel.text = car.regNumSpaces
                self.regionLabel.text = car.region
                Session.session.carID = car.carID
            }
        }
        
        userPicImageView.image = service.loadImageFromDiskWith(fileName: "userPic")
    }

    @IBAction func goToPayment(_ sender: Any) {
        performSegue(withIdentifier: paySegueID, sender: self)
    }
    
    @objc func goToUserProfile(recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: profileSegueID, sender: self)
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
            let car = Car()
            car.carID = carResponse.id
            car.regNum = carResponse.regNum
            car.regNumSpaces = self!.service.createRegNumSpaces(regNum: carResponse.regNum)
            car.region = self!.service.createRegion(regNum: carResponse.regNum)
            self?.service.saveDataInRealmWithDeletingOld(object: car, objectType: Car.self)
            self?.carNumLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            self?.regionLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            self?.carNumLabel.text = car.regNumSpaces
            self?.regionLabel.text = car.region
        }
    }
}
