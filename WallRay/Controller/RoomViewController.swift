//
//  RoomViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 31.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import Parse
import UIKit

class RoomViewController : UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource  {
    var navigationReference = CustomNavViewController()
    var number = 0
    var room : Room? = nil
    var changeLogEntries : [ChangelogEntry] = []
    var stromLenght: Float = 0
    var wasserLenght: Float = 0
    @IBOutlet weak var labelLinien: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var StartARTop: RoundedButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var changelogCollectionView: UICollectionView!
    @IBOutlet weak var statsCollectionView: UICollectionView!
    
    /**
     * Executed after view loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.backgroundColor = UIColor.clear
        topView.layer.cornerRadius = 12
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topView.layer.shadowOpacity = 0.7
        topView.layer.shadowRadius = 10
        
        self.title = "Room " + String(self.room!.number)
    }
    
    /**
     * Executed before view loads
     */
    override func viewWillAppear(_ animated: Bool) {
        var counter = 0
        // Count the amount of lines
        /*let query = PFQuery(className: "Line")
        query.whereKey("roomId", contains: self.room!.id)
        query.findObjectsInBackground ( block: { (lines, error) in
            if error == nil {
                for line in lines! {
                    counter = counter + 1
                    let color = line["Color"] as! String
                    let newline = Line(start: Point(x: line["StartX"] as! Float, y: line["StartY"] as! Float, z: line["StartZ"] as! Float), end: Point(x: line["EndX"] as! Float, y: line["EndY"] as! Float, z: line["EndZ"] as! Float), color: color)
                    // Add the line length from every line
                    self.lineLenght = self.lineLenght + newline.length()
                    
                    if(color == "Red")
                    {
                        self.stromLenght = self.stromLenght + newline.length()
                    }
                    else if(color == "Blue")
                    {
                        self.wasserLenght = self.wasserLenght + newline.length()
                    }
                }
            }
            
            self.labelLinien?.text = String(counter)
        })*/
        
        for line in (room?.lines)! {
            counter = counter + 1
            if(line.type == 1)
            {
                self.stromLenght = self.stromLenght + line.length()
            }
            else if(line.type == 2)
            {
                self.wasserLenght = self.wasserLenght + line.length()
            }
        }
        
        self.labelLinien?.text = String(counter)
    }
    
    /**
     * Executed after view loaded
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * Executed when view disappers
     */
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    /**
     * Executed when the view was scrolled
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >=  -50) {
            self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navigationBarBackground"), for: .default)
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
    }
    
    /**
     * Button click event to start AR view
     */
    @IBAction func buttonClickShow(_ sender: Any) {
        // Get AR view from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
        
        // Pass the room object
        vc.room = self.room
        
        // Show view
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     * Returns the amount of cells
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.changelogCollectionView)
        {
            if((room?.changelogEntries.count)! > 0)
            {
                return (room?.changelogEntries.count)!
            }
            else
            {
                return 1
            }
        } else if (collectionView == self.statsCollectionView) {
            return 3
        }
        return 0
    }
    
    /**
     * Creates the cells in the CollectionView
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = changelogCollectionViewCell()
        if (collectionView == self.changelogCollectionView) {
            let cell = changelogCollectionView.dequeueReusableCell(withReuseIdentifier: "changelogCollectionCell", for: indexPath) as! changelogCollectionViewCell
            
            if((room?.changelogEntries.count)! > 0)
            {
                let rowEntry = room?.changelogEntries[indexPath.row]
            
                cell.cellLabelName.text = rowEntry?.username
                
                cell.cellLabelDate.text = "21.06.2018"
                cell.cellLabelStatus.text = rowEntry?.type
            }
            else
            {
                cell.cellLabelName.text = "No changelog entries"
                
                cell.cellLabelDate.text = ""
                cell.cellLabelStatus.text = ""
            }
            cell.layer.cornerRadius = 15
            cell.layer.masksToBounds = true
            return cell
        } else if (collectionView == self.statsCollectionView) {
            let cell = statsCollectionView.dequeueReusableCell(withReuseIdentifier: "statsCollectionCell", for: indexPath) as! statsCollectionViewCell
            
            if(indexPath.row == 0)
            {
                cell.cellLabelName.text = "Länge insgesamt"
                cell.cellLabelDate.text = String(stromLenght + wasserLenght)
            }
            else if(indexPath.row == 1)
            {
                cell.cellLabelName.text = "Länge Stromkabel"
                cell.cellLabelDate.text = String(stromLenght)
            }
            else if(indexPath.row == 2)
            {
                cell.cellLabelName.text = "Länge Wasserleitungen"
                cell.cellLabelDate.text = String(wasserLenght)
            }
            
            cell.layer.cornerRadius = 15
            cell.layer.masksToBounds = true
            return cell
        }
        return cell
    }
}

