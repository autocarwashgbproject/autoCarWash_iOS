//
//  AboutAppViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 08/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func useConditionsPressed(_ sender: UIButton) {
        WebViewURL.webViewURL.url = "https://github.com/"
    }
    
    @IBAction func confPolicyPressed(_ sender: UIButton) {
        WebViewURL.webViewURL.url = "https://apple.com/"
    }
    
    
}
