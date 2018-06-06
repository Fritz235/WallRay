//
//  ChangeLog.swift
//  WallRay
//
//  Created by Fritz Oppelt on 04.06.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import Parse

class ChangeLog {
    var logId: Int
    var userId: Int
    var linienId: Int
    
    var logs: [ChangeLog] = []
  
    init(logId: Int, userId: Int, linienId: Int) {
        self.linienId = linienId
        self.logId = logId
        self.userId = userId
    }
    
    func updateChangeLog(logId: Int, userId: Int, linienId: Int)
    {
        
         
    }

}
