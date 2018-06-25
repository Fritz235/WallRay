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
    var start: Point
    var end: Point
    var color: UIColor 
    
    init(start: Point, end: Point, color: String) {
        self.start = start
        self.end = end
        
        if(color == "Red")
        {
            self.color = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 1)
        }
        else if(color == "Blue")
        {
            self.color = UIColor(displayP3Red: 0, green: 0, blue: 1, alpha: 1)
        }
        else
        {
            self.color = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
