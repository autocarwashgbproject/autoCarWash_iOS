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


class GetSMSResponse: Codable {
    
    var ok: Bool?
    var phone: String?
    var sms_for_tests: Int?
    var error_code: Int?
    var description: String?
    var detail: String?

}

class ClientAuthResponse: Codable {
    
    var ok: Bool?
    var token: String?
    var id: Int?
    var is_registered: Bool?
    var phone: String?
    var cars_id: [Int]?
    var error_code: Int?
    var description: String?
    var detail: String?
    
}

class UserResponse: Codable {
    
    var ok: Bool?
    var id: Int?
    var name: String?
    var surname: String?
    var patronymic: String?
    var phone: String?
    var email: String?
    var is_birthday: Bool?
    var birthday: Int?
    var cars_id: [Int]?
    var error_code: Int?
    var description: String?
    var detail: String?
    
}

class LogoutDeleteResponse: Codable {
    
    var ok: Bool?
    var id: Int?
    var description: String?
    
}

class CarResponse: Codable {
    
    var ok: Bool?
    var id: Int?
    var reg_num: String?
    var is_subscribe: Bool?
    var subscription_date: Int?
    var subscription_date_validation: Int?
    var error_code: Int?
    var description: String?
    var detail: String?
    
}

class HistoryResponse: Codable {
    
    var ok: Bool?
    var washing: [WashResponse]
    
}

class WashResponse: Codable {
    
    var id: Int?
    var washing: String?
    var is_active: Bool?
    var timestamp: Int?
    var user: Int?
    var car: Int?
    var wash: Int?
    
}

class HistoryResponse1: Mappable {
    
    var ok = false
    var washing = [WashResponse1]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        ok <- map["ok"]
        washing <- map["washing"]
    }
}

class WashResponse1: Mappable {
    
    var id = 0
    var washing = ""
    var isActive = false
    var washTime = 0
    var userID = 0
    var carID = 0
    var wash = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
        func mapping(map: Map) {
            id <- map["id"]
            washing <- map["washing"]
            isActive <- map["is_active"]
            washTime <- map["timestamp"]
            userID <- map["user"]
            carID <- map["car"]
            wash <- map["wash"]
    }
}
