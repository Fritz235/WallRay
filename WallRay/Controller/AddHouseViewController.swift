//
//  TableViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import UIKit
import Parse
class AddHouseViewController: UIViewController {

    @IBOutlet weak var textFieldStreet: UITextField!
    @IBOutlet weak var textFieldHousenumber: UITextField!
    
    var nextId = "0"
    
    /**
     * Executed after the view loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a tap gesture to hide the keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    /**
     * Executed before the view loads
     */
    override func viewWillAppear(_ animated: Bool) {
        
        // Generates the next free id
        let query = PFQuery(className: "House")
        
        query.order(byDescending: "houseId")
        query.findObjectsInBackground ( block: { (rooms, error) in
            if error == nil {
                // Get the last id
                let id = rooms![0]["houseId"] as! String
        
                // Increment it by 1
                var tempId = Int(id)
                tempId = tempId! + 1
                
                // Save as nextId
                self.nextId = String(tempId!)
            }
        })
    }
    
    /**
     * Executed when the app receives a memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * Adds the house to the database
     */
    @IBAction func buttonClick(_ sender: UIButton) {
        let house = PFObject(className:"House")
        house["houseId"] = nextId
        house["street"] = textFieldStreet?.text
        house["housenumber"] = textFieldHousenumber?.text
        house.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                // When successful return to the listview
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Error")
            }
        }
    }
    
    /**
     * Dismisses the keyboard
     */
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

