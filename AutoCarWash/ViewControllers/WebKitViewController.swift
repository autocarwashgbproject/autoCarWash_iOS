//
//  UseConditionsViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 16/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    let url = "https://google.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarImage()
        
        let urlRequest = URL(string: url)
        let URL = URLRequest(url: urlRequest!)
        webView.load(URL)
        
    }
}

