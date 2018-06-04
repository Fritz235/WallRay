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
    var room: Room?
    var roomnumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for line in self.lines {
            let startPoint = SCNVector3(x: (line?.start.x)!, y: (line?.start.y)!, z: (line?.start.z)!)
            let endPoint = SCNVector3(x: (line?.end.x)!, y: (line?.end.y)!, z: (line?.end.z)!)
            
            let line = SCNGeometry.line(from: startPoint, to: endPoint)
            let lineNode = SCNNode(geometry: line)
            
            lineNode.position = SCNVector3Zero
            sceneView.scene.rootNode.addChildNode(lineNode)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
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
        self.title = String(roomnumber)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLines()
    {
        let planquery = PFQuery(className: "Line")
        //roomquery.whereKeyExists("planId")
        planquery.whereKey("roomId", contains: String(self.roomnumber))
        planquery.findObjectsInBackground ( block: { (lines, error) in
            
            //print(rooms[0]["number"])
            if error == nil {
                for line in lines! {
                    self.lines.append(Line(objectId: 1, start: Point(x: line["StartX"] as! Float, y: line["StartY"] as! Float, z: line["StartZ"] as! Float), end: Point(x: line["EndX"] as! Float, y: line["EndY"] as! Float, z: line["EndZ"] as! Float)))
                }
                
            }
        })
    }
}
