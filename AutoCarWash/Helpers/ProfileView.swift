//
//  ProfileView.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 06/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 15
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = #colorLiteral(red: 0.837210238, green: 0.8303549886, blue: 0.8998547196, alpha: 1)
        self.layer.shadowRadius = 10
    }

}
