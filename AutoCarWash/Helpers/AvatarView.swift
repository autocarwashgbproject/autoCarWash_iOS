//
//  AvatarView.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 08/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class AvatarView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.layer.frame.width / 2
        self.layer.borderColor = #colorLiteral(red: 0.1648069918, green: 0.2871948481, blue: 0.4310556054, alpha: 1)
        self.layer.borderWidth = 0.6
    }

}
