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
        
        userNameLabel.text = User.user.shortName
        userTelNumLabel.text = User.user.telNumber
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "paymentSegue" else { return }
        guard Car.car.region != "" else { sendAlert(title: "Вам нужен автомобиль", message: "Пожалуйста, укажите номер автомобиля для оплаты абонемента"); return }
    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        WebViewURL.webViewURL.url = "https://google.com/"
    }
    
    @IBAction func abuotAppButtonPressed(_ sender: UIButton) {
        WebViewURL.webViewURL.url = "https://twitter.com/"
    }
    
}
