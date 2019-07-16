//
//  Categories.swift
//  Todoey
//
//  Created by Ivan Martin on 15/03/2019.
//  Copyright © 2019 Ivan Martin. All rights reserved.
//

import Foundation
import RealmSwift
//for realm
class Categories: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    //relationship
    let items = List<Items>()
}
