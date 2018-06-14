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
    var lineId: Int
    var roomId: Int
    var type: String
  
    init(username: String, lineId: Int, roomId: Int, type: String) {
        self.username = username
        self.lineId = lineId
        self.roomId = roomId
        self.type = type
    }
}
