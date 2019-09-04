//
//  PaymentViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 08/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var checkDataLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var toPaymentButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var carNumLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var line5: UIImageView!
    let paySegueID = "toPaymentSegue"
    let service = Service()
    let request = AlamofireRequests()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        Запрос на сервер о наличии абонемента
//        Если есть абонемент
//        checkDataLabel.text = "Абонемент оплачен"
//        toPaymentButton.isHidden = true
//        priceLabel.isHidden = true
//        infoLabel.isHidden = true
//        sumLabel.isHidden = true
//        line4.isHidden = true
        
        service.loadUserFromRealm() { user in
            self.userNameLabel.text = "\(user.firstName) \(user.surname)"
        }
        
        service.loadCarFromRealm() { car in
            guard car.regNum != "" else { return }
            self.carNumLabel.text = "\(car.regNumSpaces) \(car.region) RUS"
        }
    }
    
    @IBAction func goToPayment(_ sender: Any) {
        guard userNameLabel.text != "",
            carNumLabel.text != "" else { return }
        WebViewURL.webViewURL.url = "https://kassa.yandex.ru"
        performSegue(withIdentifier: paySegueID, sender: self)
    }
}
