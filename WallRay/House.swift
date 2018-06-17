//
//  Raum.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import Parse

class House {
    var id: String
    var street: String
    var housenumber: String
    
    init(id: String, street: String, housenumber: String) {
        self.id = id
        self.street = street
        self.housenumber = housenumber
    }
    
    convenience init(parseObject: PFObject) {
        self.init(id: parseObject["houseId"] as! String, street: parseObject["street"] as! String, housenumber: parseObject["housenumber"] as! String)
    }
}
