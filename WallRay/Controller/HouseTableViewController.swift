//
//  TableViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 30.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import UIKit
import Parse
class HouseTableViewController: UITableViewController {
    var houses: [House] = []
    let cellReuseIdentifier = "cell"
    
    /**
     * Executed after the view loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    /**
     * Executed before the view loads
     */
    override func viewWillAppear(_ animated: Bool) {
        // Load data and update table before view loads
        updateTable()
    }
    
    /**
     * Execetud when the app receives a memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * Loads data from the database and stores them in an array to fill the TableView
     */
    func updateTable() {
        // Clear the house array
        houses.removeAll(keepingCapacity: false)
        
        // Get houses from database
        let housequery = PFQuery(className: "House")
        housequery.order(byAscending: "street")
        housequery.findObjectsInBackground ( block: { (houses, error) in
            if error == nil {
                for house in houses! {
                    // Store house in house array
                    self.houses.append(House(parseObject: house))
                }
            }
            
            // Reload the table view to display data
            self.tableView.reloadData()
        })
    }
    
    /**
     * Returns the number of rows
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    /**
     * Add cell to the TableView
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HouseTableViewCell
        
        // Get the house object from the house array
        let rowHouse = houses[indexPath.row]
        
        // Store the id in the tag attribute for later use
        cell.tag = Int(rowHouse.id)!
        
        // Fill the textfields of the cell
        cell.houseInhaberView?.text = rowHouse.owner
        cell.houseNameView?.text = rowHouse.street + " " + String(rowHouse.housenumber)
        
        // Add border and color
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    /**
     * Touch cell event
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        // Get the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        // Get the next view from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RoomTableViewController") as! TableViewController
        
        // Get house id from which is stored in the tag attribute
        vc.houseId = String(currentCell.tag)
        
        // Set title for the next view
        vc.title = String(houses[(indexPath?.row)!].street) + " " + String(houses[(indexPath?.row)!].housenumber)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     * Swipe cell event
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // If the delete button is touched
        if editingStyle == .delete {
            // Delete the cell's house from the database
            let query = PFQuery(className: "House")
            query.whereKey("houseId", equalTo: houses[indexPath.row].id)
            query.findObjectsInBackground ( block: { (houses, error) in
                if error == nil {
                    for house in houses! {
                        house.deleteEventually()
                    }
                }
            })
            
            // Delete all room connected to the house
            let roomquery = PFQuery(className: "Raum")
            roomquery.whereKey("houseId", equalTo: houses[indexPath.row].id)
            roomquery.findObjectsInBackground ( block: { (rooms, error) in
                if error == nil {
                    for room in rooms! {
                        room.deleteEventually()
                        
                        // Delete all line connected to the room
                        let linequery = PFQuery(className: "Line")
                        linequery.whereKey("roomId", equalTo: room["roomId"] as! String)
                        linequery.findObjectsInBackground ( block: { (lines, error) in
                            if error == nil {
                                for line in lines! {
                                    line.deleteEventually()
                                }
                            }
                        })
                    }
                }
            })
            
            // Delete the house from the array and tableview
            houses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

