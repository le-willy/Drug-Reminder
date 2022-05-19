//
//  DrugModel.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit
import RealmSwift

class DrugModel: Object {

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var drugName: String = ""
    @objc dynamic var drugCatergory: String = ""
    @objc dynamic var numberOfDoses: String = ""
    
    var dosingTime = List<DosingTime>()

    override static func primaryKey() -> String? {
        return "id"
    }
}


