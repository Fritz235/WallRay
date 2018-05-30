//
//  Line.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import Parse

class Line {
    var objectId: Int
    var start: Point
    var end: Point
    
    init(objectId: Int, start: Point, end: Point) {
        self.objectId = objectId
        self.start = start
        self.end = end
    }
}
