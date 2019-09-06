//
//  RegistrationVewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 02/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationUserViewController: UIViewController {
    
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var telNumLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var IAgreeImageView: UIImageView!
    let service = Service()
    let request = AlamofireRequests()
    let userDefaults = UserDefaults.standard
    let regCarSegueID = "toCarRegistr"
    let readUserCondSegueID = "toWebViewSegue"
    var userTelNum = 0
    var userTelNumSp = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setNavBarImage()
        
        hideNavBarItem()
        
        userTelNum = userDefaults.integer(forKey: "telNum")
        userTelNumSp = userDefaults.string(forKey: "telNumSpaces")!
        telNumLabel.text = userTelNumSp
        
//        Распознавание тапа по вьюшке "я согласем с условиями"
        let IAgreeTap = UITapGestureRecognizer(target: self, action: #selector(agreeTap(recognizer:)))
        IAgreeImageView.isUserInteractionEnabled = true
        IAgreeImageView.addGestureRecognizer(IAgreeTap)
    }
    
//    Тап по картинкам "я согласем с условиями"
    @objc func agreeTap(recognizer: UITapGestureRecognizer){
        changeState(imageView: IAgreeImageView)
    }
    
//    Регистрация пользователя по нажатию кнопки "Далее"
    @IBAction func registration(_ sender: Any) {
        guard let surname = surnameTextField.text,
              let name = nameTextField.text,
              let patronymic = patronymicTextField.text,
              let email = emailTextField.text else { return }
        guard surname != "",
              name != "" else { sendAlert(title: "Заполнены не все поля", message: "Пожалуйста, заполните все поля, помеченные звёздочкой"); return }
        guard IAgreeImageView.image == UIImage(named: "Rectangle 3_filled")  else { sendAlert(title: "Заполнены не все поля", message: "Пожалуйста, подтвердите Ваше согласие с условиями пользования"); return}
        let userParameters: Parameters = ["name": name,
                                          "surname": surname,
                                          "patronymic": patronymic,
                                          "phone": userTelNum,
                                          "email": email,
                                          "is_birthday": false,
                                          "birthday": 0]
        request.clientSetDataRequest(parameters: userParameters) { [weak self] userResponse in
            print("REGISTRATION USER: \(userResponse.toJSON())")
            guard userResponse.ok else { self?.sendAlert(title: "Что-то пошло не так", message: "Произошла ошибка. \(userResponse.errorDescription)"); return }
             self?.performSegue(withIdentifier: self!.regCarSegueID, sender: self)
        }
    }
    
//    Смена картинки с пустого квадрата на заполненный и наоборот
    func changeState(imageView: UIImageView){
        if imageView.image == UIImage(named: "Rectangle 3") {
            imageView.image = UIImage(named: "Rectangle 3_filled")
        } else {
            imageView.image = UIImage(named: "Rectangle 3")
        }
    }
    
//    Переход на страницу с текстом условий пользования
    @IBAction func readUseCondition(_ sender: UIButton) {
        let webView = WebViewURL.webViewURL
        webView.url = "https://geekbrains.ru/"
        performSegue(withIdentifier: readUserCondSegueID, sender: self)
    }
}
