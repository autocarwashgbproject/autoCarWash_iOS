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
    @IBOutlet weak var telNumTextField: UITextField!
    @IBOutlet weak var telNumLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    let birthdayPicker = UIDatePicker()
    let userPicPicker = UIImagePickerController()
    var userPic = UIImage()
    let service = Service()
    let alamofireRequest = AlamofireRequests()
    var userRLM: User?
    var userTelNum = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        telNumTextField.isHidden = true
        
        addDatePicker()
        
        userRLM = service.loadUserFromRealm()
        
        guard let user = userRLM else { return }
        
        userTelNum = user.telNum
        nameTextField.text = user.firstName
        surnameTextField.text = user.surname
        patronymicTextField.text = user.patronymic
        telNumLabel.text = "\(user.telNumString)"
        emailTextField.text = user.email
        birthdayTextField.text = user.birthdayString
        
        userPicImageView.image = service.loadImageFromDiskWith(fileName: "userPic")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        
        userPicPicker.delegate = self
        
        let userPicTap = UITapGestureRecognizer(target: self, action: #selector(changeUserPic(recognizer:)))
        userPicImageView.isUserInteractionEnabled = true
        userPicImageView.addGestureRecognizer(userPicTap)
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
        formatter.dateFormat = "dd.MM.yyyy"
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
        var birthDayUNIX = 1
        guard nameTextField.text != "",
              surnameTextField.text != "" else { sendAlert(title: "Заполнены не все поля", message: "Поля 'Имя' и 'Фамилия' не могут быть пустыми") ; return }
        if birthdayTextField.text != "" {
            let dateOfBirth = service.stringToDate(dateString: birthdayTextField.text!)
            birthDayUNIX = service.dateToUnixtime(date: dateOfBirth)
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
                                          "birthday": birthDayUNIX]
        alamofireRequest.clientSetDataRequest(parameters: userParameters) { [weak self] userResponse in
            print(userResponse.toJSON())
            if userResponse.ok == true {
                do {
                    let realm = try Realm()
                    let user = realm.objects(User.self).first!
                    try realm.write {
                        user.setValue(userResponse.firstName, forKey: "firstName")
                        user.setValue(userResponse.surname, forKey: "surname")
                        user.setValue(userResponse.patronymic, forKey: "patronymic")
                        user.setValue(userResponse.email, forKey: "email")
                        user.setValue(userResponse.birthday, forKey: "birthday")
                        user.setValue(self!.birthdayTextField.text, forKey: "birthdayString")
                    }
                } catch {
                    print(error)
                }
                self?.sendAlert(title: "Данные сохранены", message: "Ваш профиль успешно обновлён")
            } else {
                self?.sendAlert(title: "Не удалось обновить профиль", message: "Пожалуйста, проверьте правильность введённых данных")
            }
        }

        service.saveImage(imageName: "userPic", image: userPic)
//        Отправить на сервер новые данные
    }
    
//    Выход
    @IBAction func logOut(_ sender: Any) {
        service.deleteDataFromRealm()
        performSegue(withIdentifier: "logOutSegue", sender: self)
    }
    
//    Удаление аккаунта
    @IBAction func deleteAccuont(_ sender: Any) {
        deleteAlert()
    }
    
//    Алерт с предупреждением об удалении аккаунта
    func deleteAlert() {
        let alert = UIAlertController(title: "Удалить аккаунт?", message: "Вы уверены, что хотите удалить аккаунт? Данные будут удалены безвозвратно", preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let actionYes = UIAlertAction(title: "Да", style: .default, handler: { actionYes in
            self.service.deleteDataFromRealm()
            self.alamofireRequest.deleteDataFromServer()
            self.performSegue(withIdentifier: "logOutSegue", sender: self)
        })
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true, completion: nil)
    }
    
//    Функции выбора юзерпика
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
