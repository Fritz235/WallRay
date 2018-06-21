//
//  ARViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 31.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import ARKit
import Parse

extension SCNGeometry {
    class func line(from vector1: SCNVector3, to vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
}

class ARViewController : UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var lines: [Line?] = []
    
    var room : Room? = nil
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (ARConfiguration.isSupported) {
            print("Supported")// ARKit is supported. You can work with ARKit
        } else {
            print("Not supported")
            // ARKit is not supported. You cannot work with ARKit
        }
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        
        loadLines()
        
        self.title = String(self.room!.number)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func render() {
        
        //for line in lines {
            //let node = SCNGeometry.line(from: SCNVector3(x: (line?.start.x)!, y: (line?.start.y)!, z: (line?.start.z)!), to: SCNVector3(x: (line?.end.x)!, y: (line?.end.y)!, z: (line?.end.z)!))
            
            let node = SCNGeometry.line(from: SCNVector3(x: -1, y: 0, z: 0), to: SCNVector3(x: -4, y: 0, z: 0))
        
            let lineNode = SCNNode(geometry: node)
        
            lineNode.position = SCNVector3Zero
            
            sceneView.scene.rootNode.addChildNode((lineNode))
       // }
        //node.position = SCNVector3Zero
        
    }
    
    func loadLines()
    {
        let linequery = PFQuery(className: "Line")
        //roomquery.whereKeyExists("planId")
        linequery.whereKey("roomId", contains: self.room!.id)
        //linequery.whereKey("roomnumber", contains: String(self.room!.number))
        linequery.findObjectsInBackground ( block: { (lines, error) in
            
            //print(rooms[0]["number"])
            if error == nil {
                for line in lines! {
                    self.lines.append(Line(objectId: 1, start: Point(x: line["StartX"] as! Float, y: line["StartY"] as! Float, z: line["StartZ"] as! Float), end: Point(x: line["EndX"] as! Float, y: line["EndY"] as! Float, z: line["EndZ"] as! Float)))
                }
                
            }
        })
    }
}
