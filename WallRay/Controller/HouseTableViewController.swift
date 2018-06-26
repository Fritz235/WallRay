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
    //var room = [PFObject]()
    var houses: [House] = []
    
    var refresher: UIRefreshControl = UIRefreshControl()
    
    @IBAction func logoutUser(_ sender: Any) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
    }
    
    func updateTable() {
        houses.removeAll(keepingCapacity: false)
        
        let housequery = PFQuery(className: "House")
        //roomquery.whereKeyExists("planId")
        housequery.order(byAscending: "street")
        housequery.findObjectsInBackground ( block: { (houses, error) in
            
            //print(rooms[0]["number"])
            if error == nil {
                for house in houses! {
                    self.houses.append(House(parseObject: house))
                }
                
            }
            
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        //updateTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTable()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HouseTableViewCell
        let rowHouse = houses[indexPath.row]
        cell.tag = Int(rowHouse.id)!
        cell.houseInhaberView?.text = "Rene"
        cell.houseNameView?.text = "Galaafksld"
        //cell.textLabel?.text = String(rowHouse.street) + " " + String(rowHouse.housenumber)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RoomTableViewController") as! TableViewController
        vc.houseId = String(currentCell.tag)
        vc.title = String(houses[(indexPath?.row)!].street) + " " + String(houses[(indexPath?.row)!].housenumber)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let query = PFQuery(className: "House")
            query.whereKey("houseId", equalTo: houses[indexPath.row].id)
            query.findObjectsInBackground ( block: { (houses, error) in
                if error == nil {
                    for house in houses! {
                        house.deleteEventually()
                    }
                }
            })
            
            let roomquery = PFQuery(className: "Raum")
            roomquery.whereKey("houseId", equalTo: houses[indexPath.row].id)
            roomquery.findObjectsInBackground ( block: { (rooms, error) in
                if error == nil {
                    for room in rooms! {
                        room.deleteEventually()
                        
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
            
            
            
            houses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

