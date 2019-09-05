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
    let request = AlamofireRequests()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Загрузка пользователя с сервера и отображение данных
        request.getUserDataRequest() { [weak self] user in
            self?.userNameLabel.text = "\(user.firstName) \(user.patronymic) \(user.surname)"
            self?.userTelNumLabel.text = "+7-\(self!.service.createTelNumString(user.telNum))"
        }
    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        WebViewURL.webViewURL.url = "https://google.com/"
    }
    
    @IBAction func abuotAppButtonPressed(_ sender: UIButton) {
        WebViewURL.webViewURL.url = "https://twitter.com/"
    }
    
}
