//
//  DrugModel.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit
import RealmSwift

class DrugModel: Object {
    @objc dynamic var drugName: String = ""
    @objc dynamic var drugCatergory: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var numberOfDoses: String = ""
    @objc dynamic var time1: String = ""
    @objc dynamic var time2: String = ""
    @objc dynamic var time3: String = ""
    @objc dynamic var time4: String = ""
}
