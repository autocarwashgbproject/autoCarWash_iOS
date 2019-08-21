//
//  ResponseObjects.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 20/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class RegistrTelNumResponse: Mappable {
    
    var ok = false
    var error = 0
    var errorDescription = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        ok <- map["ok"]
        error <- map["error_code"]
        errorDescription <- map["description"]
    }
}

class ClientAuthResponse: Mappable {
    
    var ok = false
    var token = ""
    var userID = 0
    var isRegistr = false
    var telNum = 0
    var error = 0
    var errorDescription = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        ok <- map["ok"]
        token <- map["token"]
        userID <- map["id"]
        isRegistr <- map["is_registered"]
        telNum <- map["tel_num"]
        error <- map["error_code"]
        errorDescription <- map["description"]
    }
}

