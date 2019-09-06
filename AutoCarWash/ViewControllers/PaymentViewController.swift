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
    var extend: Bool!
    var isSubscribe: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkDataLabel.text = ""
        toPaymentButton.isHidden = true
        priceLabel.isHidden = true
        infoLabel.isHidden = true
        sumLabel.isHidden = true
        line5.isHidden = true
        
        let extendTap = UITapGestureRecognizer(target: self, action: #selector(extendSubscript(recognizer:)))
        extendAutomaticallyImageView.isUserInteractionEnabled = true
        extendAutomaticallyImageView.addGestureRecognizer(extendTap)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        userNameLabel.text = User.user.shortName
        carNumLabel.text = "\(Car.car.regNum) \(Car.car.region) RUS"
        
        request.getCarDataRequest() { [weak self] carResponse in
            guard carResponse.ok else { return }
            if carResponse.isSubscribe {
                self?.isSubscribe = true
                self?.checkDataLabel.text = "Абонемент оплачен"
                self?.toPaymentButton.isHidden = true
                self?.priceLabel.isHidden = true
                self?.infoLabel.isHidden = true
                self?.sumLabel.isHidden = true
                self?.line5.isHidden = true
                let beginDate = self?.service.getDateFromUNIXTime(date: carResponse.beginDate)
                self?.startSubscriptionLabel.text = beginDate
//                if carResponse.autoExtend {
//                  extendAutomaticallyImageView.image = UIImage(named: "Rectangle 3_blue")
//              } else {
//                  extendAutomaticallyImageView.image = UIImage(named: "Rectangle 3")
//              }
            } else {
                self?.isSubscribe = false
                self?.checkDataLabel.text = "Проверьте Ваши данные"
                self?.toPaymentButton.isHidden = false
                self?.priceLabel.isHidden = false
                self?.infoLabel.isHidden = false
                self?.sumLabel.isHidden = false
                self?.line5.isHidden = false
                self?.startSubscriptionLabel.text = Date.getCurrentDate()
            }
        }
    }
    
//    Переход к оплате абонемента с передачей нужных параметров
    @IBAction func goToPayment(_ sender: Any) {
        guard carNumLabel.text != "" else { sendAlert(title: "Укажите номер автомобиля", message: "Поле 'Гос. номер' не может быть пустым. Пожалуйста, перейдите в профиль и укажите номер автомобиля"); return }
        WebViewURL.webViewURL.url = "https://kassa.yandex.ru"
        performSegue(withIdentifier: paySegueID, sender: self)
    }
    
//    Тап по квадратику "Продлевать автоматически"
    @objc func extendSubscript(recognizer: UIGestureRecognizer) {
        if isSubscribe {
            changeStateSubscribe(imageView: extendAutomaticallyImageView)
        } else {
            changeStateNoSubscribe(imageView: extendAutomaticallyImageView)
        }
    }
    
//    Тап по квадратику, если подписки нет
    func changeStateNoSubscribe(imageView: UIImageView) {
        if imageView.image == UIImage(named: "Rectangle 3") {
            imageView.image = UIImage(named: "Rectangle 3_blue")
            extend = true
        } else {
            imageView.image = UIImage(named: "Rectangle 3")
            extend = false
        }
    }
    
//    Тап по квадратику, если подписка есть
    func changeStateSubscribe(imageView: UIImageView) {
        if imageView.image == UIImage(named: "Rectangle 3") {
            extendAlert(title: "Продлевать подписку?", message: "Нажимая 'Да', вы соглашаетесь на автоматическое продление абонемента. После окончания периода с Вашей карты автоматически спишется ₽2000. Продолжить?") {
//                Запрос на сервер, продлевать существующую подписку
                print("EXTEND SUBSCRIBE")
                imageView.image = UIImage(named: "Rectangle 3_blue")
            }
        } else {
            extendAlert(title: "Отменить автопродление?", message: "Нажимая 'Да', Вы отказываетесь от автоматического продления подписки. Продолжить?") {
//                Запрос на сервер, отменить продление существующей подписки
                print("DON'T EXTEND SUBSCRIBE")
                imageView.image = UIImage(named: "Rectangle 3")
            }
        }
    }
    
    func extendAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let actionYes = UIAlertAction(title: "Да", style: .default, handler: { actionYes in
            completion()
        })
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true, completion: nil)
    }
}
