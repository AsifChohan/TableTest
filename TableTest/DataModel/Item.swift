//
//  Item.swift
//  TableTest
//
//  Created by AlveenaFalaq on 1/21/18.
//  Copyright © 2018 AlveenaFalaq. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var item : String = ""
    @objc dynamic var state : Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
