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
    
    let headers: HTTPHeaders = ["Authorization": "Token \(Session.session.token)"]
    
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
    
//    Запрос регистрации пользователя
    func clientRegistrRequest(parameters: Parameters, completion: @escaping (UserResponse) -> Void) {
        
        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/"
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<UserResponse>) in
            guard let userResponse = response.result.value else { return }
            completion(userResponse)
        }
    }
    
//    Запрос на получение данных пользователя
    func getUserDataRequest(completion: @escaping (UserResponse) -> Void) {

        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/"
        Alamofire.request(url, method: .get, headers: headers).responseObject { (response: DataResponse<UserResponse>) in
            guard let user = response.result.value else { return }
            completion(user)
        }
    }
    
    func deleteDataFromServer(){
//        Запрос на сервер об удаленеии даных
    }
}
