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
    
//    Запрос на получение данных пользователя
    func getUserRequest(completion: @escaping (User) -> Void) {

        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/"
        Alamofire.request(url).responseObject { (response: DataResponse<User>) in
            guard let user = response.result.value else { return }
            completion(user)
        }
    }
    
//    Запрос "Авторизация клиента"
    func clientAuthRequest(telNum: Int, smsCode: Int, completion: @escaping (ClientAuthResponse) -> Void) {

        let url = "http://185.17.121.228/api/v1/clients/register/"
        let parameters = ["tel_num": "\(telNum)", "sms_code": "\(smsCode)"]
        Alamofire.request(url, method: .post, parameters: parameters).responseObject { (response: DataResponse<ClientAuthResponse>) in
            guard let authResponse = response.result.value else { return }
            completion(authResponse)
        }
    }
    
    func clientRegistrRequest(parameters: Parameters) {
        
        let url = "http://185.17.121.228/api/v1/clients/\(Session.session.userID)/"
        Alamofire.request(url, method: .put, parameters: parameters)
    }
    
    func deleteDataFromServer(){
//        Запрос на сервер об удаленеии даных
    }
}
