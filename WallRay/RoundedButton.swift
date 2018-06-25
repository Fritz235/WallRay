//
//  RoundedButton.swift
//  WallRay
//
//  Created by Felix Ohlsen on 24.06.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import UIKit
@IBDesignable

class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: CGColor = UIColor.clear.cgColor {
        didSet {
            self.layer.borderColor = borderColor
        }
    }
}
