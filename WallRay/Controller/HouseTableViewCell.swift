//
//  HouseTableViewCell.swift
//  WallRay
//
//  Created by Fritz Oppelt on 26.06.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import UIKit

class HouseTableViewCell: UITableViewCell {
    @IBOutlet weak var houseImageView: UIImageView!
    @IBOutlet weak var houseInhaberView: UILabel!
    @IBOutlet weak var houseNameView: UILabel!
    
    var house: House?
    {
        didSet
        {
            self.updateUI()
        }
    }

    func updateUI()
    {
        //house.swift braucht noch die nötigen instanzen
        //houseImageView?.image = house?.image
        houseInhaberView?.text = house?.id
        houseNameView?.text = house?.street
    }
}
