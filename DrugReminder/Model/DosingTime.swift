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




