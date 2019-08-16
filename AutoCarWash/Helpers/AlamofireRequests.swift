//
//  AlamofireRequests.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 13/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireRequests {
    
    func getRequest(url: String) {
        
        Alamofire.request(url).responseJSON { response in
            print (response)
        }
    }
    
//    Пример запроса, данные от балды)
    func postRequest(url: String, parameters: Parameters) {

        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            print(response)
        }
    }
    
    func deleteDataFromServer(){
//        Запрос на сервер об удаленеии даных
    }
}
