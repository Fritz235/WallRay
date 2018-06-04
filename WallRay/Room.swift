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
    var objectId: Int
    var number: Int
    
    init(objectId: Int, number: Int) {
        self.objectId = objectId
        self.number = number
    }
    
    convenience init(parseObject: PFObject) {
        self.init(objectId: 1, number: parseObject["number"] as! Int)
    }
}
