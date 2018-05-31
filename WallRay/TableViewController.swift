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
    //var room = [PFObject]()
    var rooms: [Raum] = []
    var numbers = [""]
    var objectIds = [""]
    
    var refresher: UIRefreshControl = UIRefreshControl()
    
    @IBAction func logoutUser(_ sender: Any) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
    }
    
    func updateTable() {
        let roomquery = PFQuery(className: "Raum")
        //roomquery.whereKeyExists("planId")
        roomquery.findObjectsInBackground ( block: { (rooms, error) in
            
            //print(rooms[0]["number"])
            if error == nil {
                for room in rooms! {
                    //print(room["objectId"])
                    print(room["number"])
                    print(room["planId"])
                    self.rooms.append(Raum(objectId: 1, number: room["number"] as! Int, planId: room["planId"] as! Int))
                        
                    }
              
            }
            
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
       
        updateTable()
        
    }
    
    override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
         let rowRoom = rooms[indexPath.row]
         cell.textLabel?.text = String(rowRoom.number)
         return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        //getting the text of that cell
        let currentItem = currentCell.textLabel!.text
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RoomViewController") as! RoomViewController
        vc.number = 200
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

