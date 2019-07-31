//
//  User.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 31/07/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {

    @objc dynamic var firstName = ""
    @objc dynamic var surname = ""
    @objc dynamic var patronymic = ""
    @objc dynamic var telNum = ""
    @objc dynamic var email = ""
    @objc dynamic var isActive = false
    @objc dynamic var registrationDate = 0
    @objc dynamic var deleteDate = 0
    @objc dynamic var birthday = ""
    @objc dynamic var geolocation = ""
    
}
