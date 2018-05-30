//
//  Point.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import Parse

class Point {
    var objectId: Int
    var x: Float
    var y: Float
    var z: Float
    
    init(objectId: Int, x: Float, y: Float, z: Float) {
        self.objectId = objectId
        self.x = x
        self.y = y
        self.z = z
    }
}
