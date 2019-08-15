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
    
    func testRequest() {
        request("http://185.17.121.228/api/v1/clients/2/").responseJSON { response in
            print (response)
        }
    }
    
    func deleteDataFromServer(){
//        Запрос на сервер об удаленеии даных
    }
    
//    Пример запроса, данные от балды)
    func postRequest() {
        let url = "yourlink.php"
        let parameters: Parameters = ["parameter1": "value1", "parameter2": "value2", "parameter3": "value3"]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            print(response)
        }
    }
    
}
