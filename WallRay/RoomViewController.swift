//
//  RoomViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 31.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import UIKit

class RoomViewController : UIViewController {
    var number = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print(number)
        self.title = "Room " + String(number)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
