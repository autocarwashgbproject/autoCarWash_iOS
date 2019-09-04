//
//  File.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 31/07/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import RealmSwift

class Car: Object {
    
    @objc dynamic var carID = 0
    @objc dynamic var regNum = ""
    @objc dynamic var regNumSpaces = ""
    @objc dynamic var region = ""
    
    override static func primaryKey() -> String? {
        return "carID"
    }
}
