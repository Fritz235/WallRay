//
//  TableViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import UIKit
import Parse
class TableViewController: UITableViewController {
    
    var numbers = [""]
    var objectIds = [""]
    
    var refresher: UIRefreshControl = UIRefreshControl()
    
    @IBAction func logoutUser(_ sender: Any) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
    }
    
    @objc func updateTable() {
        
        let query = PFQuery(className: "Raum")
        
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            
            
            print(objects?.count)
            
        })
        
        
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*var raum = PFObject(className:"Raum")
        raum["number"] = 1337
        raum["planId"] = 1
        raum.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                print("success")// The object has been saved.
            } else {
                print("failed")// There was a problem, check error.description
            }
        }*/
        
        updateTable()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
