//
//  HistoryViewController.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 08/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var historyTableView: UITableView!
    let eventsArr = [Event(eventType: "Оплата", eventDate: "20.08.2019"),
                    Event(eventType: "Мойка", eventDate: "25.08.2019"),
                    Event(eventType: "Мойка", eventDate: "28.08.2019"),
                    Event(eventType: "Мойка", eventDate: "1.09.2019"),
                    Event(eventType: "Мойка", eventDate: "5.09.2019"),
                    Event(eventType: "Мойка", eventDate: "10.09.2019"),]
//    let eventsArr = [Event]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Запрос на сервер, получаем список событий, отображаем в таблице
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if eventsArr.count >= 1 {
            return eventsArr.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        if eventsArr.count >= 1 {
            cell.infoLabel.isHidden = true
            let event = eventsArr[indexPath.row]
            cell.eventDateLabel.text = event.eventDate
            cell.eventTypeLabel.text = event.eventType
            if event.eventType == "Мойка" {
                cell.eventImageView.image = #imageLiteral(resourceName: "bubbles")
            } else {
                cell.eventImageView.image = #imageLiteral(resourceName: "coin")
            }
        } else {
            cell.infoLabel.isHidden = false
            cell.eventImageView.image = #imageLiteral(resourceName: "bubbles")
        }
        return cell
    }
}