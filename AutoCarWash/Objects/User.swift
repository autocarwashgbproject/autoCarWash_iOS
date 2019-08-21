//
//  User.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 31/07/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class User: Object, Mappable {

    @objc dynamic var userID = 0
    @objc dynamic var firstName = ""
    @objc dynamic var surname = ""
    @objc dynamic var patronymic = ""
    @objc dynamic var telNum = 0
    @objc dynamic var telNumString = ""
    @objc dynamic var email = ""
    @objc dynamic var birthday = 0
    @objc dynamic var birthdayString = ""
    @objc dynamic var geolocation = ""
    var ok = false
    var error = 0
    var errorDescription = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
     func mapping(map: Map) {
        userID <- map["id"]
        firstName <- map["first_name"]
        surname <- map["surname"]
        patronymic <- map["patronymic"]
        telNum <- map["tel_num"]
        email <- map["email"]
        birthday <- map["birthday"]
        ok <- map["ok"]
        error  <- map["error_code"]
        errorDescription <- map["description"]
    }
}
