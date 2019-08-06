//
//  Service.swift
//  AutoCarWash
//
//  Created by Olga Lidman on 05/08/2019.
//  Copyright © 2019 Home. All rights reserved.
//

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
            user = realm.objects(User.self).first!
        } catch {
            print(error)
        }
        return user
    }
    
//    Преобразование текущей даты в Int от UnixTime
    func dsateToUnixtime(date: Date) -> Int {
        let timeInterval = date.timeIntervalSince1970
        return Int(timeInterval)
    }
    
}
