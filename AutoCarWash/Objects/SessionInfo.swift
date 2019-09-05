//
//  SessionRLM.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 05/09/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import RealmSwift

class SessionInfo: Object {
    
    @objc dynamic var userID = 0
    @objc dynamic var carID = 0
    @objc dynamic var token = ""
    
}
