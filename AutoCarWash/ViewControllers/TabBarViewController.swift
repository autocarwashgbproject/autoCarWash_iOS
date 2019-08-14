//
//  TabBarViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 09/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarImage()
        
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.1803921569, green: 0.5921568627, blue: 0.662745098, alpha: 1)
        
    }
}
