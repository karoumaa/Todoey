//
//  Category.swift
//  Todoey
//
//  Created by user on 11/11/2018.
//  Copyright © 2018 karama. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var  name : String = ""
    let items = List<Item>()
}
