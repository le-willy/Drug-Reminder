//
//  DosingTime.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/22.
//

import Foundation
import RealmSwift

class DosingTime: Object {
    @objc dynamic var at: Date?
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: DrugModel.self, property: "dosingTime")


}

func getRecords(by targetDate: Date) -> [DosingTime]? {
    let calendar = Calendar(identifier: .gregorian) // Calendarクラスをインスタンス化
    let startPoint = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: targetDate)! // 指定された日付(targetDate)の0時0分0秒の日付をstartPointとしてインスタンス化
    let endPoint = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: targetDate)! // 指定された日付(targetDate)の23時59分59秒の日付をendPointとしてインスタンス化
    let realm = try! Realm() // Realmをインスタンス化
    let result = realm.objects(DosingTime.self)
        .filter("at BETWEEN {%@, %@}", startPoint, endPoint) // DosingTime.atが指定された日付(targetDate)の0時0分0秒から23時59分59秒までの間に合致するデータのみをフィルタリング
    return Array(result)
     // 対象となるデータリスト(todayRecordList)の日付(DosingTime.at)を昇順でソートして返す
}


