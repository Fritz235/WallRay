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
    var nextId = ""
    
    @IBOutlet weak var textFieldNumber: UITextField!
    
    @IBAction func logoutUser(_ sender: Any) {
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        let room = PFObject(className:"Raum")
        room["roomId"] = nextId
        room["number"] = Int((textFieldNumber?.text)!)
        room["houseId"] = houseId
        room.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Error")
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //nextId = getNextId()
        //var nextId = ""
        let query = PFQuery(className: "Raum")
        
        query.order(byDescending: "roomId")
        query.findObjectsInBackground ( block: { (rooms, error) in
            
            //print(rooms[0]["number"])
            if error == nil {
                let id = rooms![0]["roomId"] as! String
                var tempId = Int(id)
                tempId = tempId! + 1
                //print(tempId!)
                self.nextId = String(tempId!)
                //nextId = tempId as! String
                //print(nextId)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

