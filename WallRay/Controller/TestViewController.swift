//
//  TestViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 24.06.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    @IBOutlet weak var roundedShowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonDesign()
    }
    
    func setButtonDesign() {
        roundedShowButton.layer.cornerRadius = 10
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
