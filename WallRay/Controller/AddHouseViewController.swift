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
    
    var nextId = ""
    
    @IBAction func logoutUser(_ sender: Any) {
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        let house = PFObject(className:"House")
        house["houseId"] = nextId
        house["street"] = textFieldStreet?.text
        house["housenumber"] = textFieldHousenumber?.text
        house.saveInBackground {
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
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nextId = "0"
        
        let query = PFQuery(className: "House")
        
        query.order(byDescending: "houseId")
        query.findObjectsInBackground ( block: { (rooms, error) in
            if error == nil {
                let id = rooms![0]["houseId"] as! String
        
                var tempId = Int(id)
                tempId = tempId! + 1
                
                self.nextId = String(tempId!)
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

