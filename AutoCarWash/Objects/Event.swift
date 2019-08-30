//
//  Event.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 08/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

class Event: Comparable {
    
    var eventType: String
    var eventDate: String
    var timeInt: Int
    var success: Bool
    var description: String
    
    init(eventType: String, eventDate: String, timeInt: Int, success: Bool, description: String) {
        self.eventType = eventType
        self.eventDate = eventDate
        self.timeInt = timeInt
        self.success = success
        self.description = description
    }
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.timeInt < rhs.timeInt
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.timeInt == rhs.timeInt
    }
}
