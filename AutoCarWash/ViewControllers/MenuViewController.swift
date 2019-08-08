//
//  MenuViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 08/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import RealmSwift

class MenuViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTelNumLabel: UILabel!
    let service = Service()
    var userRLM: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Загрузка данных пользователя для отображения
        userRLM = service.loadUserFromRealm()
        guard let user = userRLM else { return }
        userNameLabel.text = "\(user.firstName) \(user.patronymic) \(user.surname)"
        userTelNumLabel.text = user.telNum
    }
}
