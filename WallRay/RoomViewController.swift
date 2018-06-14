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
    
    @IBOutlet weak var StartAR: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(number)
        self.title = "Room " + String(number)
        
        var entry = ChangelogEntry(username: "Hallo", lineId: 1, roomId: 1, type: "");
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
        
        vc.roomnumber = number
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
