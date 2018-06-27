//
//  ChangeLog.swift
//  WallRay
//
//  Created by Fritz Oppelt on 04.06.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import Parse

class ChangelogEntry {
    var username: String
    var lineId: String
    var roomId: String
    var type: String
  
    init(username: String, lineId: String, roomId: String, type: String) {
        self.username = username
        self.lineId = lineId
        self.roomId = roomId
        self.type = type
    }
    
    convenience init(parseObject: PFObject) {
        self.init(username: parseObject["username"] as! String, lineId: parseObject["lineId"] as! String, roomId: parseObject["roomId"] as! String, type: parseObject["type"] as! String)
    }
}
