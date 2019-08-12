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
        
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.7540792823, green: 0.8779987097, blue: 0.8976370692, alpha: 1)
        
    }
}
