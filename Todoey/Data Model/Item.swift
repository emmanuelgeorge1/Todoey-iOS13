//
//  Data Model.swift
//  Todoey
//
//  Created by Emmanuel George on 31/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
class Item: Codable{
    var title:String = ""
    var done:Bool = false
}
