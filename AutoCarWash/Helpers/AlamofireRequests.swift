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
    func getSMS(telNum: String,  completion: @escaping (GetSMSResponse) -> Void) {
        let parameters: Parameters = ["phone": telNum]
        let url = "http://185.17.121.228/api/v1/clients/sms/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData() { response in
            guard let data = response.value else { return }
            let smsResponse: GetSMSResponse = try! JSONDecoder().decode(GetSMSResponse.self, from: data)
            completion(smsResponse)
        }
    }
    
//    Запрос "Авторизация клиента"
    func clientAuthRequest(telNum: String, code: Int, completion: @escaping (ClientAuthResponse) -> Void) {
        let url = "http://185.17.121.228/api/v1/clients/register/"
        let parameters = ["phone": telNum, "otp": "\(code)"]
        Alamofire.request(url, method: .post, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let authResponse: ClientAuthResponse = try! JSONDecoder().decode(ClientAuthResponse.self, from: data)
            completion(authResponse)
        }
    }
    
//    Запрос на получение данных пользователя
    func getUserDataRequest(completion: @escaping (UserResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/"
        Alamofire.request(url, method: .get, headers: headers).responseData { response in
            guard let data = response.value else { return }
            let userResponse: UserResponse = try! JSONDecoder().decode(UserResponse.self, from: data)
            completion(userResponse)
        }
    }
    
//    Запрос на внесение изменений в данные пользователя
    func clientSetDataRequest(parameters: Parameters, completion: @escaping (UserResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/"
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            guard let data = response.value else { return }
            let userResponse: UserResponse = try! JSONDecoder().decode(UserResponse.self, from: data)
            completion(userResponse)
        }
    }
    
//    Запрос на выход из аккаунта
    func logoutRequest(completion: @escaping (LogoutDeleteResponse) -> Void) {
       let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/logout/"
        Alamofire.request(url, method: .delete, headers: headers).responseData { response in
            guard let data = response.value else { return }
            let logoutResponse: LogoutDeleteResponse = try! JSONDecoder().decode(LogoutDeleteResponse.self, from: data)
            completion(logoutResponse)
        }
    }
    
//    Запрос на удаление данных пользователя
    func deleteUserRequest(completion: @escaping (LogoutDeleteResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/"
        Alamofire.request(url, method: .delete, headers: headers).responseData{ response in
            guard let data = response.value else { return }
            let deleteResponse: LogoutDeleteResponse = try! JSONDecoder().decode(LogoutDeleteResponse.self, from: data)
            completion(deleteResponse)
        }
    }
    
// MARK - Запросы по автомобилю - регистрация, получение данных, редактирование, удаление
//    Запрос на регистрацию авто
    func carRegistrationRequest(regNum: String, completion: @escaping (CarResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/cars/"
        let carParameters: Parameters = ["reg_num": "\(regNum)"]
        Alamofire.request(url, method: .post, parameters: carParameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            guard let data = response.value else { return }
            let carResponse: CarResponse = try! JSONDecoder().decode(CarResponse.self, from: data)
            completion(carResponse)
        }
    }
    
//    Запрос на получение данных авто
    func getCarDataRequest(completion: @escaping (CarResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/cars/\(Session.session.carID)/"
        Alamofire.request(url, method: .get, headers: headers).responseData { response in
            guard let data = response.value else { return }
            let carResponse: CarResponse = try! JSONDecoder().decode(CarResponse.self, from: data)
            completion(carResponse)
        }
    }
    
//    Запрос на редактирование номера авто
    func carSetDataRequest(regNum: String, completion: @escaping (CarResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/cars/\(Session.session.carID)/"
        let carParameters: Parameters = ["reg_num": "\(regNum)"]
        Alamofire.request(url, method: .put, parameters: carParameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            guard let data = response.value else { return }
            let carResponse: CarResponse = try! JSONDecoder().decode(CarResponse.self, from: data)
            completion(carResponse)
        }
    }
    
//    Запрос на подключение/отмену автопродления подписки
//    func extendSubscribe(extend: Bool, completion: @escaping (CarResponse) -> Void) {
//        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
//        let url = "http://185.17.121.228/api/v1/cars/\(Session.session.carID)/"
//        let extendParameters: Parameters = ["is_regular_pay": extend]
//        Alamofire.request(url, method: .put, parameters: extendParameters, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<CarResponse>) in
//            guard let car = response.result.value else { return }
//            completion(car)
//        }
//    }
    
//    Запрос на удаление авто
    func deleteCarRequest(completion: @escaping (CarResponse) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/cars/\(Session.session.carID)/"
        Alamofire.request(url, method: .delete, headers: headers).responseData { response in
            guard let data = response.value else { return }
            let deleteCarResponse: CarResponse = try! JSONDecoder().decode(CarResponse.self, from: data)
            completion(deleteCarResponse)
        }
    }
    
//    Запрос истории помывок
    func getWashHistory(completion: @escaping ([WashResponse]) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
        let url = "http://185.17.121.228/api/v1/washing/\(Session.session.userID)/"
        Alamofire.request(url, method: .get, headers: headers).responseObject {(response: DataResponse<HistoryResponse>) in
            guard let historyResponse = response.result.value else { return }
            let history = historyResponse.washing
            completion(history)
        }
    }
}
