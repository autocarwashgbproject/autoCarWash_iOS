//
//  Service.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 05/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift   

class Service {
    
//    Сохранение данных в  Realm
    func saveDataInRealm(object: Object, objectType: Object.Type) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(object)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
//    Загрузка данных сессии из Realm
    func loadSessionInfoFromRealm(completion: (SessionInfo) -> Void) {
        var sessionInfo = SessionInfo()
        do {
            let realm = try Realm()
            sessionInfo = realm.objects(SessionInfo.self).first ?? sessionInfo
        } catch {
          print(error)
        }
        completion(sessionInfo)
    }
    
//    Удаление данных из Realm
    func deleteDataFromRealm() {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
//    Преобразование даты в Int от UnixTime
    func dateToUnixtime(date: Date) -> Int {
        let timeInterval = date.timeIntervalSince1970
        return Int(timeInterval)
    }
    
//    Получение даты из формата UNIXTime
    func getDateFromUNIXTime(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
//    Получение времени из формата UNIXTime
    func getTimeFromUNIXTime(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
//    Преобразование строки с датой в формат Date
    func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
//    Получение "красивого" номера телефона для отображения на экранах
    func createTelNumString(_ telnum: String) -> String {
        guard telnum != "" else { return ""}
        let telNumArr = Array(telnum)
        let telNumSp = [telNumArr[0], telNumArr[1], telNumArr[2], "-",telNumArr[3], telNumArr[4],  telNumArr[5], "-", telNumArr[6], telNumArr[7], telNumArr[8], telNumArr[9]]
        let telNumSpaces = String(telNumSp)
        return telNumSpaces
    }
    
//    Получение "красивого" номера машины и региона
    func createRegNumSpaces(regNum: String) -> String {
        guard regNum != "" else { return  "" }
        let regNumArr = Array(regNum)
        let regNumSp = [regNumArr[0], " ", regNumArr[1], regNumArr[2], regNumArr[3], " ", regNumArr[4], regNumArr[5]]
        let regNumSpaces = String(regNumSp)
        return(regNumSpaces)
    }
    
//    Получение региона
    func createRegion(regNum: String) -> String {
        guard regNum != "" else { return "" }
        var regNumArr = Array(regNum)
        for _ in 1...6 {
            regNumArr.removeFirst()
        }
        let region = String(regNumArr)
        return(region)
    }
    
//    Cохранение изображения
    func saveImage(imageName: String, image: UIImage) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
//    Удаление изображения
    func deleteImage(imageName: String, image: UIImage){
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
    }
    
//    Загрузка изображения
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
}

extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
}
