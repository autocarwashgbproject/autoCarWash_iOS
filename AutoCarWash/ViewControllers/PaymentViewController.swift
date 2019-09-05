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
    @IBOutlet weak var startSubscriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var line5: UIImageView!
    @IBOutlet weak var extendAutomaticallyImageView: UIImageView!
    let paySegueID = "toPaymentSegue"
    let service = Service()
    let request = AlamofireRequests()
    var extend = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let extendTap = UITapGestureRecognizer(target: self, action: #selector(extendSubscript(recognizer:)))
        extendAutomaticallyImageView.isUserInteractionEnabled = true
        extendAutomaticallyImageView.addGestureRecognizer(extendTap)
        
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
//        startSubscriptionLabel.text = время начала абонемента из ответа сервера
        startSubscriptionLabel.text = Date.getCurrentDate()
        
        request.getUserDataRequest() { [weak self] user in
            self?.userNameLabel.text = "\(user.firstName) \(user.surname)"
        }
        
        request.getCarDataRequest() { [weak self] car in
            guard car.regNum != "" else { return }
            let regNumSpaces = self!.service.createRegNumSpaces(regNum: car.regNum)
            let region = self!.service.createRegion(regNum: car.regNum)
            self?.carNumLabel.text = "\(regNumSpaces) \(region) RUS"
        }
    }
    
    @IBAction func goToPayment(_ sender: Any) {
        guard userNameLabel.text != "",
            carNumLabel.text != "" else { return }
        WebViewURL.webViewURL.url = "https://kassa.yandex.ru"
        performSegue(withIdentifier: paySegueID, sender: self)
    }
    
    @objc func extendSubscript(recognizer: UIGestureRecognizer) {
        changeState(imageView: extendAutomaticallyImageView)
    }
    
    func changeState(imageView: UIImageView){
        if imageView.image == UIImage(named: "Rectangle 3") {
            imageView.image = UIImage(named: "Rectangle 3_blue")
            extend = true
        } else {
            imageView.image = UIImage(named: "Rectangle 3")
            extend = false
        }
    }
}
