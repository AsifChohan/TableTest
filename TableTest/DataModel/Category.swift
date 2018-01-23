//
//  Category.swift
//  TableTest
//
//  Created by AlveenaFalaq on 1/21/18.
//  Copyright © 2018 AlveenaFalaq. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
