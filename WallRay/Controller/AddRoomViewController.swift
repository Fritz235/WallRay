//
//  TableViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import UIKit
import Parse
class AddRoomViewController: UIViewController {
    var houseId = ""
    var nextId = "0"
    
    @IBOutlet weak var textFieldNumber: UITextField!
    
    /**
     * Executed after the view loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        textFieldNumber.setLeftPaddingPoints(10)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    /**
     * Executed before the view loads
     */
    override func viewWillAppear(_ animated: Bool) {
        let query = PFQuery(className: "Raum")
        
        query.order(byDescending: "roomId")
        query.findObjectsInBackground ( block: { (rooms, error) in
            if error == nil {
                let id = rooms![0]["roomId"] as! String
            
                var tempId = Int(id)
                tempId = tempId! + 1
            
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
     * Button click event to add a room to the database
     */
    @IBAction func buttonClick(_ sender: UIButton) {
        let room = PFObject(className:"Raum")
        room["roomId"] = nextId
        room["number"] = Int((textFieldNumber?.text)!)
        room["houseId"] = houseId
        room.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                // If succussful return to the listview
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

