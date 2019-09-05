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

//        Запрос на сервер о состоянии подписки, результат отобразить в subscribeStatusLabel
//        Если есть активная подписка, payButton.isHidden = true
        subscribeStatusLabel.isHidden = true
        
//        Загрузка пользователя с сервера и отображение данных
        reguest.getUserDataRequest() { [weak self] userResponse in
            print("GET USER: \(userResponse.toJSON())")
            if userResponse.detail == "Недопустимый токен." {
                self?.service.deleteDataFromRealm();
                self?.performSegue(withIdentifier: self!.authorisationSegueID, sender: self);
                return
            }
            self?.userNameLabel.text = "\(userResponse.firstName) \(userResponse.patronymic) \(userResponse.surname)"
            self?.userTelNumberLabel.text = self?.service.createTelNumString(userResponse.telNum)
            self?.userEmailLabel.text = userResponse.email
        }
        
        let toProfileTap = UITapGestureRecognizer(target: self, action: #selector(goToUserProfile(recognizer:)))
        userProfileView.isUserInteractionEnabled = true
        userProfileView.addGestureRecognizer(toProfileTap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        Загрузка авто с сервера и отображение данных
        reguest.getCarDataRequest() { [weak self] car in
            print("GET CAR: \(car.toJSON())")
            if car.regNum == "" {
                self?.carNumLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                self?.regionLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                self?.carNumLabel.text = "x000xx"
                self?.regionLabel.text = "000"
            } else {
                self?.carNumLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                self?.regionLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                self?.carNumLabel.text = self?.service.createRegNumSpaces(regNum: car.regNum)
                self?.regionLabel.text = self?.service.createRegion(regNum: car.regNum)
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
}
