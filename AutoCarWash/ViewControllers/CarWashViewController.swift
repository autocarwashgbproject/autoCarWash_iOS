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
    let service = Service()
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        Запрос на сервер о состоянии подписки, результат отобразить в subscribeStatusLabel
        
        user = service.loadUserFromRealm()
        
        guard let userToShow = user else { return }
        
        userNameLabel.text = "\(userToShow.firstName) \(userToShow.patronymic) \(userToShow.surname)"
        userTelNumberLabel.text = userToShow.telNum
        userEmailLabel.text = userToShow.email
        
    }

}
