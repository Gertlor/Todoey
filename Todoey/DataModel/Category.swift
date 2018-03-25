//
//  Category.swift
//  Todoey
//
//  Created by Gerrit Louis on 25-03-18.
//  Copyright © 2018 Gerrit Louis de Beuze. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
