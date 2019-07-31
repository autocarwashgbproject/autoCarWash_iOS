//
//  Message.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 31/07/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object {
    
    @objc dynamic var messageDate = 0
    @objc dynamic var messageText = ""
    @objc dynamic var messageStatus = false
    @objc dynamic var clientID = 0
    
}
