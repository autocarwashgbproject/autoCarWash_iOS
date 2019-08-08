//
//  CarWashViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 06/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class CarWashViewController: UIViewController {
    
    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTelNumberLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var subscribeStatusLabel: UILabel!
    @IBOutlet weak var carNumLabel: UILabel!
    let service = Service()
    var user : User?
    var car : Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        Запрос на сервер о состоянии подписки, результат отобразить в subscribeStatusLabel
        
//        Загрузка данных пользователя из Realm
        user = service.loadUserFromRealm()
        
        guard let userToShow = user else { return }
        
        userNameLabel.text = "\(userToShow.firstName) \(userToShow.patronymic) \(userToShow.surname)"
        userTelNumberLabel.text = userToShow.telNum
        userEmailLabel.text = userToShow.email
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        Загрузка даных авто из Realm
        car = service.loadCarFromRealm()
        guard let carToShow = car else { return }
        if carToShow.regNumSpaces != "" {
            carNumLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            carNumLabel.text = "\(carToShow.regNumSpaces) rus"
        } else {
            carNumLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            carNumLabel.text = "x000xx00"
        }
    }

}