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

}
