//
//  Raum.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import Parse

class Raum {
    var objectId: Int
    var number: Int
    var planId: Int
    
    init(objectId: Int, number: Int, planId: Int) {
        self.objectId = objectId
        self.number = number
        self.planId = planId
    }
    
    convenience init(parseObject: PFObject) {
        self.init(objectId: 1, number: parseObject["number"] as! Int, planId: parseObject["planId"] as! Int)
    }
}
