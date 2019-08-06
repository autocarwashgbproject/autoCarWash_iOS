//
//  ProfileViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 02/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTelNumberLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var carPicImageView: UIImageView!
    @IBOutlet weak var carNumberLabel: UILabel!
    let service = Service()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserFromRealm()
        guard let userToShow = user else { return }
        userNameLabel.text = "\(userToShow.firstName) \(userToShow.patronymic) \(userToShow.surname)"
        userTelNumberLabel.text = userToShow.telNum
        userEmailLabel.text = userToShow.email
    }
    
    func loadUserFromRealm(){
        do {
            let realm = try Realm()
            self.user = realm.objects(User.self).first!
        } catch {
            print(error)
        }
    }
    
}
