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
    var rooms: [Room] = []
    var houseId = ""
    
    /**
     * Executed after view loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    /**
     * Executed before view loads
     */
    override func viewWillAppear(_ animated: Bool) {
        updateTable()
    }
    
    /**
     * Executed when the app receives a memory warning
     */
    override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
    }
    
    /**
     * Button click event to add a room
     */
    @IBAction func ButtonAddClick(_ sender: UIBarButtonItem) {
        // Get AddRoomView from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddRoomViewController") as! AddRoomViewController
        
        // Pass the houseId
        vc.houseId = self.houseId
        
        // Show next view
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     * Gets rooms from database and updates table
     */
    func updateTable() {
        // Clear room array
        rooms.removeAll(keepingCapacity: false)
        
        // Get room with a specific houseId from the database in an ascending order
        let roomquery = PFQuery(className: "Raum")
        roomquery.whereKey("houseId", contains: houseId)
        roomquery.order(byAscending: "number")
        roomquery.findObjectsInBackground ( block: { (rooms, error) in
            if error == nil {
                for room in rooms! {
                    var changelogEntries: [ChangelogEntry] = []
                    var allLines: [Line] = []
                    // Store room object in array
                    let query = PFQuery(className: "Changelog")
                    query.whereKey("roomId", contains: room["roomId"] as? String)
                    query.findObjectsInBackground ( block: { (entries, error) in
                        if error == nil {
                            for entry in entries! {
                                changelogEntries.append(ChangelogEntry(parseObject: entry))
                            }
                        }
                    })
                    let linequery = PFQuery(className: "Line")
                    linequery.whereKey("roomId", contains: room["roomId"] as? String)
                    linequery.findObjectsInBackground ( block: { (lines, error) in
                        if error == nil {
                            for line in lines! {
                                allLines.append(Line(start: Point(x: line["StartX"] as! Float, y: line["StartY"] as! Float, z: line["StartZ"] as! Float), end: Point(x: line["EndX"] as! Float, y: line["EndY"] as! Float, z: line["EndZ"] as! Float), color: line["Color"] as!  String))
                            }
                        }
                        
                        self.rooms.append(Room(parseObject: room, changelogEntries: changelogEntries, lines: allLines))
                        
                        // Reload the table to show data
                        self.tableView.reloadData()
                    })
                    
                    
                }
                
            }
            
        })
    }
    
    /**
     * Returns the number of cells in the tableview
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    /**
     * Adds cells to the tabelview
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Get room object
        let rowRoom = rooms[indexPath.row]
        
        // Write roomnumber in the textfield
        cell.textLabel?.text = String(rowRoom.number)
        return cell
    }
    
    /**
     * Touch event on a cell
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
    
        // Get the next view from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RoomViewController") as! RoomViewController
        
        // Pass the room object to the next view
        vc.room = rooms[(indexPath?.row)!]
        
        // Show next view
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     * Swipe event on a cell
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // If delete button is touched
        if editingStyle == .delete {
            // Deletes room with the cells roomId from the database
            let query = PFQuery(className: "Raum")
            query.whereKey("number", equalTo: rooms[indexPath.row].number)
            query.findObjectsInBackground ( block: { (rooms, error) in
                if error == nil {
                    for room in rooms! {
                        room.deleteEventually()
                    }
                }
            })
            
            // Delete all lines connected to the room
            let linequery = PFQuery(className: "Line")
            linequery.whereKey("roomId", equalTo: rooms[indexPath.row].number)
            linequery.findObjectsInBackground ( block: { (lines, error) in
                if error == nil {
                    for line in lines! {
                        line.deleteEventually()
                    }
                }
            })
            
            // Remove room from the array and tableview
            rooms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

