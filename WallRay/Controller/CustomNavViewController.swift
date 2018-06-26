//
//  CustomNavViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 25.06.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import UIKit

class CustomNavViewController: UINavigationController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
     self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        print()
        // Do any additional setup after loading the view.
    }
}
