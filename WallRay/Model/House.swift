//
//  Raum.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import Parse

class House {
    var id: String
    var street: String
    var housenumber: String
    var image: UIImage
    
    init(id: String, street: String, housenumber: String, image: UIImage) {
        self.id = id
        self.street = street
        self.housenumber = housenumber
        self.image = image
    }
    
    convenience init(parseObject: PFObject) {
        self.init(id: parseObject["houseId"] as! String, street: parseObject["street"] as! String, housenumber: parseObject["housenumber"] as! String, image: UIImage(named: "house.jpg")!)
        
        
        // Convert PFFile in UIImage
        /*let file = parseObject["Image"]! as! PFFile
        
        file.getDataInBackground(block: {(imageData, error) in
            if (error == nil)
            {
                // Image from Parse
                self.image = UIImage(data:imageData!)!
            }
        })*/
    }
    
    func convertImage(file: PFFile, completion: () -> ()) {
        completion()
    }
}

