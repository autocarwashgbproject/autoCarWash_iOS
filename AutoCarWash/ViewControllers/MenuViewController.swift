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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        Загрузка пользователя из Realm и отображение данных
        service.loadUserFromRealm() { user in
            userNameLabel.text = "\(user.firstName) \(user.patronymic) \(user.surname)"
            userTelNumLabel.text = "\(user.telNumString)"
        }
    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        WebViewURL.webViewURL.url = "https://google.com/"
    }
    
    @IBAction func abuotAppButtonPressed(_ sender: UIButton) {
        WebViewURL.webViewURL.url = "https://twitter.com/"
    }
    
}
