//
//  UseConditionsViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 16/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarImage()
        
        let url = URL(string: WebViewURL.webViewURL.url)
        let request = URLRequest(url: url!)
        webView.load(request)
        
    }
}

