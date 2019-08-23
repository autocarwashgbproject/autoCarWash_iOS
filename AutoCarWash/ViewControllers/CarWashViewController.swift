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
        
        if user?.firstName == "" {
            loadDataFromServerAndSaveInRLM()
        }
        
        guard let userToShow = user else { return }
        
        userNameLabel.text = "\(userToShow.firstName) \(userToShow.patronymic) \(userToShow.surname)"
        userTelNumberLabel.text = "\(userToShow.telNumString)"
        userEmailLabel.text = userToShow.email
        
//        Загрузка даных авто из Realm
        car = service.loadCarFromRealm()
        guard let carToShow = car else { return }
        if carToShow.regNumSpaces != "" {
            carNumLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            carNumLabel.text = carToShow.regNumSpaces
            regionLabel.text = carToShow.region
        } else {
            carNumLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            carNumLabel.text = "x000xx00"
        }
        
        userPicImageView.image = service.loadImageFromDiskWith(fileName: "userPic")
    }

    @IBAction func goToPayment(_ sender: Any) {
        performSegue(withIdentifier: paySegueID, sender: self)
    }
    
    func loadDataFromServerAndSaveInRLM() {
        reguest.getUserDataRequest() { [weak self] userResponse in
            let currentUser = User()
            currentUser.firstName = userResponse.firstName
            currentUser.surname = userResponse.surname
            currentUser.patronymic = userResponse.patronymic
            currentUser.telNum = userResponse.telNum
            currentUser.telNumString = self!.service.createTelNumString(String(userResponse.telNum))
            currentUser.birthday = userResponse.birthday
            if userResponse.birthday == 0 {
                currentUser.birthdayString = ""
            } else {
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
}
