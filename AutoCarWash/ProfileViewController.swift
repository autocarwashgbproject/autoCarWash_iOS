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

    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTelNumberLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var carPicImageView: UIImageView!
    @IBOutlet weak var carNumberLabel: UILabel!
    @IBOutlet weak var editCarProfileButton: UIButton!
    let service = Service()
    var user: User?
    var car: Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Проверка наличия оплаченного абонемента, если есть, прячем кнопку редактирования машины
//        editCarProfileButton.isHidden = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        Загрузка даных пользователя из Realm
        user = service.loadUserFromRealm()
        
//        Загрузка даных авто из Realm
        car = service.loadCarFromRealm()
        
        guard let userToShow = user else { return }
        
//        Отображение данных пользователя в соответствующих лэйблах
        userNameLabel.text = "\(userToShow.firstName) \(userToShow.patronymic) \(userToShow.surname)"
        userTelNumberLabel.text = userToShow.telNum
        userEmailLabel.text = userToShow.email
        
        guard let carToShow = car else { return }
        
//        Отображение данных авто в соответствующих лэйблах
        if carToShow.regNum != "" {
            carNumberLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            carNumberLabel.text = "\(carToShow.regNumSpaces) RUS"
        } else {
            carNumberLabel.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            carNumberLabel.text = "Вы не добавили информацию об автомобиле"
        }
    }
}
