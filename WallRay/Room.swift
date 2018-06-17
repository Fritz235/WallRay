//
//  Raum.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import Parse

class Room {
    var id: String
    var number: Int
    var houseId: String
    
    init(id: String, number: Int, houseId: String) {
        self.id = id;
        self.number = number
        self.houseId = houseId
    }
    
    convenience init(parseObject: PFObject) {
        self.init(id: parseObject["roomId"] as! String, number: parseObject["number"] as! Int, houseId: parseObject["houseId"] as! String)
    }
}
