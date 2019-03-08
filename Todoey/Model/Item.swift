//
//  Item.swift
//  Todoey
//
//  Created by Ivan Martin on 06/03/2019.
//  Copyright © 2019 Ivan Martin. All rights reserved.
//

import Foundation

class Item: Codable/* consist of both Encodable, Decodable*/{
    var title : String = ""
    var done : Bool = false
}
