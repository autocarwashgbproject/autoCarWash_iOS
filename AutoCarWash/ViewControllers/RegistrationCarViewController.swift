//
//  RegistrationAutoViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 13/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class RegistrationCarViewController: UIViewController {

    @IBOutlet weak var char1TextField: UITextField!
    @IBOutlet weak var char2TextField: UITextField!
    @IBOutlet weak var char3TextField: UITextField!
    @IBOutlet weak var char4TextField: UITextField!
    @IBOutlet weak var char5TextField: UITextField!
    @IBOutlet weak var char6TextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    let service = Service()
    let request = AlamofireRequests()
    let segueID = "toMainSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarImage()
        hideNavBarItem()
        
        char1TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char2TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char3TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char4TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char5TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        char6TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    
    @IBAction func saveData(_ sender: Any) {
        guard char1TextField.text != "",
            char2TextField.text != "",
            char3TextField.text != "",
            char4TextField.text != "",
            char5TextField.text != "",
            char6TextField.text != "",
            regionTextField.text != "" else { sendAlert(title: "", message: "Пожалуйста, введите номер автомобиля полностью"); return }
        let carNum = "\(char1TextField.text!.uppercased())\(char2TextField.text!)\(char3TextField.text!)\(char4TextField.text!)\(char5TextField.text!.uppercased())\(char6TextField.text!.uppercased())\(regionTextField.text!)"
        let carNumSp = "\(char1TextField.text!.uppercased()) \(char2TextField.text!)\(char3TextField.text!)\(char4TextField.text!) \(char5TextField.text!.uppercased())\(char6TextField.text!.uppercased())"
        let reg = "\(regionTextField.text!)"
        request.carRegistrationRequest(regNum: carNum) { [weak self] carResponse in
            print(carResponse.toJSON())
            guard carResponse.ok == true else { self?.sendAlert(title: "Что-то пошло не так", message: "Не удаётся зарегистрировать автомобиль.");return }
                let car = Car()
                car.carID = carResponse.id
                car.regNum = carResponse.regNum
                car.regNumSpaces = carNumSp
                car.region = reg
                self?.service.saveDataInRealmWithDeletingOld(object: car, objectType: Car.self)
            }
        performSegue(withIdentifier: segueID, sender: self)
        }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 1 {
            let nextTextField = view.viewWithTag(textField.tag + 1) as! UITextField
            nextTextField.becomeFirstResponder()
        }
    }
}
