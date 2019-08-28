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

class GetSMSResponse: Mappable {
    
    var ok = false
    var error = 0
    var errorDescription = ""
    var phone = 0
    var code = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        ok <- map["ok"]
        error <- map["error_code"]
        errorDescription <- map["description"]
        phone <- map["phone"]
        code <- map["sms_for_tests"]
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
    var carID = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        ok <- map["ok"]
        token <- map["token"]
        userID <- map["id_client"]
        isRegistr <- map["is_registered"]
        telNum <- map["phone"]
        error <- map["error_code"]
        errorDescription <- map["description"]
        carID <- map["cars_id.0"]
    }
}

class UserResponse: Mappable {
    
    var id = 0
    var firstName = ""
    var surname = ""
    var patronymic = ""
    var telNum = 0
    var email = ""
    var isBirthday = false
    var birthday = 0
    var ok = false
    var error = 0
    var errorDescription = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["name"]
        surname <- map["surname"]
        patronymic <- map["patronymic"]
        telNum <- map["phone"]
        email <- map["email"]
        isBirthday <- map["is_birthday"]
        birthday <- map["birthday"]
        ok <- map["ok"]
        error  <- map["error_code"]
        errorDescription <- map["description"]
    }
}

class CarResponse: Mappable {
    
    var id = 0
    var ok = false
    var regNum = ""
    var error = 0
    var errorDescription = ""
    var detail = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ok <- map["ok"]
        regNum <- map["reg_num"]
        error <- map["error_code"]
        errorDescription <- map["description"]
        detail <- map["detail"]
    }
}
