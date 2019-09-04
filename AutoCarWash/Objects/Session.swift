//
//  Session.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 20/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import WebKit

class Session {
    
    static let session = Session()
    
    var token = ""
    var userID = 0
    var carID = 0
    var carIDs = [Int]()
    
    private init(){}
    
}

class WebViewURL {
    
    static let webViewURL = WebViewURL()
    
    var url = ""
    
    private init(){}
    
}
