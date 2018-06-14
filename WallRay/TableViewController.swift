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
    var rooms: [Room] = []
    
    var refresher: UIRefreshControl = UIRefreshControl()
    
    @IBAction func logoutUser(_ sender: Any) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
    }
    
    func updateTable() {
        let roomquery = PFQuery(className: "Raum")
        //roomquery.whereKeyExists("planId")
        roomquery.order(byAscending: "number")
        roomquery.findObjectsInBackground ( block: { (rooms, error) in
            
            //print(rooms[0]["number"])
            if error == nil {
                for room in rooms! {
                    self.rooms.append(Room(objectId: 1, number: room["number"] as! Int))       
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RoomViewController") as! RoomViewController
        
        vc.number = Int((currentCell.textLabel?.text)!)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let query = PFQuery(className: "Raum")
            query.whereKey("number", equalTo: rooms[indexPath.row].number)
            query.findObjectsInBackground ( block: { (rooms, error) in
                if error == nil {
                    for room in rooms! {
                        room.deleteEventually()
                    }
                }
            })
            
            let linequery = PFQuery(className: "Line")
            linequery.whereKey("roomId", equalTo: rooms[indexPath.row].number)
            linequery.findObjectsInBackground ( block: { (lines, error) in
                if error == nil {
                    for line in lines! {
                        line.deleteEventually()
                    }
                }
            })
            
            rooms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

