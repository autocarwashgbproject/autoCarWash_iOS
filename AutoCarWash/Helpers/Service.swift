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
    func saveDataInRealmWithDeletingOld(object: Object, objectType: Object.Type){
        do {
            let realm = try Realm()
            let oldObject = realm.objects(objectType)
            realm.beginWrite()
            realm.delete(oldObject)
            realm.add(object)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    //    Загрузка данных пользователя из Realm
    func loadUserFromRealm() -> User {
        var user = User()
        do {
            let realm = try Realm()
            user = realm.objects(User.self).first ?? user
        } catch {
            print(error)
        }
        return user
    }
    
//    Загрузка данных автомобиля из Realm
    func loadCarFromRealm() -> Car {
        var car = Car()
        do {
            let realm = try Realm()
            car = realm.objects(Car.self).first ?? car
        } catch {
            print(error)
        }
        return car
    }
    
//    Преобразование текущей даты в Int от UnixTime
    func dateToUnixtime(date: Date) -> Int {
        let timeInterval = date.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    func getTimeFromUNIXTime(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    func createTelNumString(_ telnum: String) -> String {
        let telNumArr = Array(telnum)
        let telNumSp = [telNumArr[0], telNumArr[1], telNumArr[2], "-",telNumArr[3], telNumArr[4],  telNumArr[5], "-", telNumArr[6], telNumArr[7], telNumArr[8], telNumArr[9]]
        let telNumSpaces = String(telNumSp)
        return telNumSpaces
    }
}
