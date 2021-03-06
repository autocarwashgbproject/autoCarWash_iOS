//
//  ProfileViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 02/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var userProfileView: ProfileView!
    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTelNumberLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var carProfileView: ProfileView!
    @IBOutlet weak var carPicImageView: UIImageView!
    @IBOutlet weak var carNumberLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var editCarProfileButton: UIButton!
    let userProfileSegueID = "toUserProfileSegue"
    let carProfileSegueID = "toCarProfileSegue"
    let service = Service()
    let request = AlamofireRequests()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Тап по вьюшке с данными пользователя
        let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(goToUserProfile(recognizer:)))
        userProfileView.isUserInteractionEnabled = true
        userProfileView.addGestureRecognizer(userProfileTap)
        
//        Тап по вьюшке с данными автомобиля
        let carProfileTap = UITapGestureRecognizer(target: self, action: #selector(goToCarProfile(recognizer:)))
        carProfileView.isUserInteractionEnabled = true
        carProfileView.addGestureRecognizer(carProfileTap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        userNameLabel.text = User.user.fullName
        userTelNumberLabel.text = User.user.telNumber
        userEmailLabel.text = User.user.email
        
        if Car.car.regNum != "" {
            carNumberLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            regionLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            carNumberLabel.text = Car.car.regNum
            regionLabel.text = Car.car.region
        } else {
            carNumberLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            regionLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            carNumberLabel.text = "x000xx"
            regionLabel.text = "000"
        }
        
        userPicImageView.image = service.loadImageFromDiskWith(fileName: "userPic")

        carPicImageView.image = service.loadImageFromDiskWith(fileName: "carPic")
    }
    
//    Перехoд в профиль юзера
    @objc func goToUserProfile(recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: userProfileSegueID, sender: self)
    }
    
//    Переход в профиль авто
    @objc func goToCarProfile(recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: carProfileSegueID, sender: self)
    }
}
