//
//  AlamofireRequests.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 13/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class AlamofireRequests {
    
//    Запрос на получение смс
    func getSMS(telNum: Int, completion: @escaping (GetSMSResponse) -> Void) {
        let parameters: Parameters = ["phone": telNum]
        let url = "http://185.17.121.228/api/v1/clients/get_sms/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseObject { (response: DataResponse<GetSMSResponse>) in
            guard let smsResponse = response.result.value else { return }
            completion(smsResponse)
        }
    }
    
//    Запрос "Авторизация клиента"
    func clientAuthRequest(telNum: Int, code: Int, completion: @escaping (ClientAuthResponse) -> Void) {
        
        let url = "http://185.17.121.228/api/v1/clients/register/"
        let parameters = ["phone": "\(telNum)", "otp": "\(code)"]
        Alamofire.request(url, method: .post, parameters: parameters).responseObject { (response: DataResponse<ClientAuthResponse>) in
            guard let authResponse = response.result.value else { return }
            completion(authResponse)
        }
    }
    
//    Запрос на внесение изменений в данные пользователя
    func clientSetDataRequest(parameters: Parameters, completion: @escaping (UserResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/"
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<UserResponse>) in
            guard let userResponse = response.result.value else { return }
            completion(userResponse)
        }
    }
    
//    Запрос на получение данных пользователя
    func getUserDataRequest(completion: @escaping (UserResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/"
        Alamofire.request(url, method: .get, headers: headers).responseObject { (response: DataResponse<UserResponse>) in
            guard let user = response.result.value else { return }
            completion(user)
        }
    }
    
//    Запрос на выход из аккаунта
    func logoutRequest(completion: @escaping (UserResponse) -> Void) {
       let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/logout/"
        Alamofire.request(url, method: .post, headers: headers).responseObject { (response: DataResponse<UserResponse>) in
            guard let user = response.result.value else { return }
            completion(user)
        }
    }
    
//    Запрос на удаление данных пользователя
    func deleteUserDataFromServer() {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/"
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
            print(response)
        }
    }
    
//    Запрос на регистрацию авто
    func carRegistrationRequest(regNum: String, completion: @escaping (CarResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/cars/create/"
        let carParameters: Parameters = ["reg_num": "\(regNum)"]
        Alamofire.request(url, method: .post, parameters: carParameters, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<CarResponse>) in
            guard let car = response.result.value else { return }
            completion(car)
        }
    }
    
//    Запрос на редактирование данных авто
    func carSetDataRequest(regNum: String, completion: @escaping (CarResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/cars/\(Session.session.userID)/"
        let carParameters: Parameters = ["reg_num": "\(regNum)"]
        Alamofire.request(url, method: .put, parameters: carParameters, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<CarResponse>) in
            guard let car = response.result.value else { return }
            completion(car)
        }
    }
    
//    Запрос на получение данных авто
    func getCarDataRequest(completion: @escaping (CarResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/cars/\(Session.session.userID)/"
        Alamofire.request(url, method: .get, headers: headers).responseObject { (response: DataResponse<CarResponse>) in
            guard let car = response.result.value else { return }
            completion(car)
        }
    }
}
