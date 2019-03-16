//
//  Items.swift
//  Todoey
//
//  Created by Ivan Martin on 15/03/2019.
//  Copyright © 2019 Ivan Martin. All rights reserved.
//

import Foundation
import RealmSwift
//for realm
class Items: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    //relationship
    var parentCategory = LinkingObjects(fromType: Categories.self, property: "items")
}
