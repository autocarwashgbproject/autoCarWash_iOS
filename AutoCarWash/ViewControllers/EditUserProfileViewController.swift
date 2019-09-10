//
//  EditUserProfileViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 07/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class EditUserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var telNumLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    let birthdayPicker = UIDatePicker()
    let userPicPicker = UIImagePickerController()
    var userPic = UIImage()
    var oldImage = UIImage()
    let service = Service()
    let request = AlamofireRequests()
    var userTelNum = 0
    var isSubscription: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDatePicker()
        
        userPicPicker.delegate = self
        
        request.getUserDataRequest() { [weak self] userResponse in
            self?.userTelNum = userResponse.telNum
            self?.nameTextField.text = userResponse.firstName
            self?.surnameTextField.text = userResponse.surname
            self?.patronymicTextField.text = userResponse.patronymic
            self?.telNumLabel.text = "+7-\(self!.service.createTelNumString(userResponse.telNum))"
            self?.emailTextField.text = userResponse.email
            if userResponse.isBirthday {
                self?.birthdayTextField.text = self?.service.getDateFromUNIXTime(date: userResponse.birthday)
            } else {
                self?.birthdayTextField.text = ""
            }
        }
        
        let userPicTap = UITapGestureRecognizer(target: self, action: #selector(changeUserPic(recognizer:)))
        userPicImageView.isUserInteractionEnabled = true
        userPicImageView.addGestureRecognizer(userPicTap)
        
        userPicImageView.image = service.loadImageFromDiskWith(fileName: "userPic")
        oldImage = userPicImageView.image ?? #imageLiteral(resourceName: "circle_user")
        
        request.getCarDataRequest() { [weak self] carResponse in
            self?.isSubscription = carResponse.isSubscribe
        }
    }
    
//    Установка датапикера
    func addDatePicker(){
        birthdayPicker.datePickerMode = .date
        birthdayPicker.locale = Locale(identifier: "RU")
        birthdayTextField.inputView = birthdayPicker
        birthdayPicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
//    Обработка изменения даты
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthdayTextField.text = formatter.string(from: birthdayPicker.date)
    }
    
//    Изменение юзерпика
//    - по нажатию на аватар
    @objc func changeUserPic(recognizer: UITapGestureRecognizer) {
        pickPhotoFromLibrary(imagePicker: userPicPicker)
    }
    
//    - по нажатию на кнопку "Изменить фото"
    @IBAction func changeUserPic(_ sender: UIButton) {
        pickPhotoFromLibrary(imagePicker: userPicPicker)
    }
    
//    Удаление юзерпика
    @IBAction func deleteUserPic(_ sender: Any) {
        service.saveImage(imageName: "userPic", image: #imageLiteral(resourceName: "circle_user"))
        userPicImageView.image = #imageLiteral(resourceName: "circle_user")
    }
    
//    Сохранение изменений данных пользователя
    @IBAction func saveChanges(_ sender: Any) {
        var birthDayUNIX = 0
        var isBirthday = false
        guard nameTextField.text != "",
              surnameTextField.text != "" else { sendAlert(title: "Заполнены не все поля", message: "Поля 'Имя' и 'Фамилия' не могут быть пустыми") ; return }
        if birthdayTextField.text != "" {
            let dateOfBirth = service.stringToDate(dateString: birthdayTextField.text!)
            birthDayUNIX = service.dateToUnixtime(date: dateOfBirth)
            isBirthday = true
        }
        let userName = nameTextField.text!
        let userSurname = surnameTextField.text!
        let userPatronymic = patronymicTextField.text ?? ""
        let userEmail = emailTextField.text ?? ""
        let userParameters: Parameters = ["name": userName,
                                          "surname": userSurname,
                                          "patronymic": userPatronymic,
                                          "phone": userTelNum,
                                          "email": userEmail,
                                          "is_birthday": isBirthday,
                                          "birthday": birthDayUNIX]
        request.clientSetDataRequest(parameters: userParameters) { [weak self] userResponse in
            print("EDIT USER DATA: \(userResponse.toJSON())")
            if userResponse.ok {
                User.user.fullName = "\(userResponse.firstName) \(userResponse.patronymic) \(userResponse.surname)"
                User.user.shortName = "\(userResponse.firstName) \(userResponse.surname)"
                User.user.birthday = self!.birthdayTextField.text ?? ""
                User.user.email = userResponse.email
                self?.sendAlert(title: "Готово", message: "Ваш профиль успешно обновлён")
            } else {
                self?.sendAlert(title: "Не удалось обновить профиль", message: "Пожалуйста, проверьте правильность введённых данных")
            }
        }

        service.saveImage(imageName: "userPic", image: userPic)
    }
    
//    Выход из аккаунта
    @IBAction func logOut(_ sender: Any) {
        request.logoutRequest() { [weak self] logoutResponse in
            print("LOGOUT: \(logoutResponse.toJSON())")
            guard logoutResponse.ok else { return }
            self?.service.deleteDataFromRealm()
            self?.performSegue(withIdentifier: "logOutSegue", sender: self)
        }
    }
    
//    Удаление аккаунта
    @IBAction func deleteAccuont(_ sender: Any) {
        guard !isSubscription else { sendAlert(title: "Невозможно удалить аккаунт", message: "У Вас оплачен абонемент на пользование автомойкой. Пока подписка активна удалить аккаунт нельзя"); return }
        deleteAlert()
    }
    
//    Алерт с предупреждением об удалении аккаунта
    func deleteAlert() {
        let alert = UIAlertController(title: "Удалить аккаунт?", message: "Вы уверены, что хотите удалить аккаунт? Данные будут потеряны безвозвратно", preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let actionYes = UIAlertAction(title: "Да", style: .default, handler: { actionYes in
            self.service.deleteDataFromRealm()
            self.request.deleteUserRequest()
            self.performSegue(withIdentifier: "logOutSegue", sender: self)
        })
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true, completion: nil)
    }
    
//    MARK: - Функции выбора юзерпика
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userPic = pickedImage
            userPicImageView.image = userPic
            }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
