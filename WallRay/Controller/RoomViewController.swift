//
//  RoomViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 31.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import UIKit

class RoomViewController : UIViewController, UIScrollViewDelegate {
    var navigationReference = CustomNavViewController()
    var number = 0
    var room : Room? = nil
    
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
     * Executed after view loaded
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * Executed before view loads
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
}

extension RoomViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = changelogCollectionViewCell()
        if (collectionView == self.changelogCollectionView) {
            let cell = changelogCollectionView.dequeueReusableCell(withReuseIdentifier: "changelogCollectionCell", for: indexPath) as! changelogCollectionViewCell
            cell.cellLabelName.text = String(indexPath.row)
            cell.cellLabelDate.text = "Date"
            cell.cellLabelStatus.text = "Status"
            cell.layer.cornerRadius = 15
            cell.layer.masksToBounds = true
            return cell
        } else if (collectionView == self.statsCollectionView) {
            let cell = statsCollectionView.dequeueReusableCell(withReuseIdentifier: "statsCollectionCell", for: indexPath) as! statsCollectionViewCell
            cell.cellLabelName.text = "Statistik"
            cell.cellLabelDate.text = "Wert"
            cell.cellLabelStatus.text = "Zweiter Wert"
            cell.layer.cornerRadius = 15
            cell.layer.masksToBounds = true
            return cell
        }
        return cell
    }
}
