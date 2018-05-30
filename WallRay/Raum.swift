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
}
