//
//  Plan.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import Parse

class Plan {
    var objectId: Int
    var planId: Int
    var lines: [Line?] = []
    
    init(objectId: Int, planId: Int) {
        self.objectId = objectId
        self.planId = planId
    }
    
    func addLine(line: Line) {
        lines.append(line)
    }
    
    func getLines() -> [Line?] {
        return lines
    }
}
