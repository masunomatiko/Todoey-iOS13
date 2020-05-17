//
//  Category.swift
//  Todoey
//
//  Created by 佐藤万莉 on 2020/05/14.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}
