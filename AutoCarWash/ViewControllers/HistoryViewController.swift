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
    let service = Service()
    let request = AlamofireRequests()
    var eventsArr = [Event]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHistoryAndShow()
        addRefreshControl()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventsArr.count > 0 {
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
            cell.eventTypeLabel.text = event.description
            if event.success == true {
                cell.eventTypeLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            } else {
                cell.eventTypeLabel.textColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
            }
//            if event.eventType == "Мойка" {
                cell.eventImageView.image = #imageLiteral(resourceName: "bubbles")
//            } else {
//                cell.eventImageView.image = #imageLiteral(resourceName: "coin")
//            }
        } else {
            cell.infoLabel.isHidden = false
            cell.infoLabel.text = "Здесь будет отображаться история моек и оплат"
            cell.eventImageView.image = #imageLiteral(resourceName: "bubbles")
        }
        return cell
    }
    
    func getHistoryAndShow() {
        request.getHistory() { [weak self] history in
            print("HISTORY: \(history.toJSON())")
            self?.eventsArr.removeAll()
            for event in history {
                let washingTime = self?.service.getDateFromUNIXTime(date: event.washTime)
                let description = self!.ifSuccessWash(description: event.washing)
                let wash = Event(eventType: "Мойка", eventDate: washingTime ?? "no date", timeInt: event.washTime, success: event.isActive, description: description)
                self?.eventsArr.append(wash)
            }
            self?.eventsArr.sort(){$0 > $1}
            self?.historyTableView.reloadData()
        }
    }
    
    func ifSuccessWash(description: String) -> String {
        switch description {
        case "Success":
            return "Мойка";
        case "No subscription":
            return "Нет абонемента";
        case "Already washed today":
            return "Сенодня Вы мыли машину"
        default:
            return "Мойка"
        }
    }
    
    func addRefreshControl() {
        refreshControl.tintColor = #colorLiteral(red: 0.7540792823, green: 0.8779987097, blue: 0.8976370692, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refreshHistory), for: .valueChanged)
        historyTableView.addSubview(refreshControl)
    }
    
    @objc func refreshHistory() {
        getHistoryAndShow()
        refreshControl.endRefreshing()
    }
}
