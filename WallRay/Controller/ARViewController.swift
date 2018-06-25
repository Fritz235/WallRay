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

// https://github.com/shu223/ARKit-Sampler/blob/master/common/Common.swift
func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

extension SCNVector3
{
    // Get vector length
    func length() -> Float {
        return sqrtf(x*x + y*y + z*z)
    }
    
    static func eulerAngles(vector: SCNVector3) -> SCNVector3 {
        let height = vector.length()
        let lxz = sqrtf(vector.x * vector.x + vector.z * vector.z)
        let pitchB = vector.y < 0 ? Float.pi - asinf(lxz/height) : asinf(lxz/height)
        let pitch = vector.z == 0 ? pitchB : sign(vector.z) * pitchB
        
        var yaw: Float = 0
        if vector.x != 0 || vector.z != 0 {
            let inner = vector.x / (height * sinf(pitch))
            if inner > 1 || inner < -1 {
                yaw = Float.pi / 2
            } else {
                yaw = asinf(inner)
            }
        }
        return SCNVector3(CGFloat(pitch), CGFloat(yaw), 0)
        /*
        let height = vector.length()
        
        let lxz = sqrtf(vector.x * vector.x + vector.z * vector.z)
        
        var pitchB : Float = 0
        
        if(vector.y < 0)
        {
            pitchB = Float.pi - asinf(lxz/height)
        }
        else
        {
            asinf(lxz/height)
        }
        
        var x: Float = 0
        
        if(vector.z == 0)
        {
            x = pitchB
        }
        else
        {
            x = sign(vector.z) * pitchB
        }
        
        var y: Float = 0
        
        if (vector.x != 0 || vector.z != 0)
        {
            let inner = vector.x / (height * sinf(x))
            
            if inner > 1 || inner < -1
            {
                y = Float.pi / 2
            }
            else
            {
                y = asinf(inner)
            }
        }
        
        return SCNVector3(CGFloat(x), CGFloat(y), 0)*/
    }
}

extension SCNNode {
    static func line(from: SCNVector3, to: SCNVector3) -> SCNNode {
        // Get direction vector
        let direction = to - from
        
        // Get distance between both points
        let distance = direction.length()
        
        // Create cylinder with the distance as length
        let cylinder = SCNCylinder(radius: 0.01, height: CGFloat(distance))
        cylinder.radialSegmentCount = 4
        
        let node = SCNNode(geometry: cylinder)
        
        
        // Place cylinder in between both points
        node.position = (to + from) / 2
        
        // rotate cylinder to the direction vector
        node.eulerAngles = SCNVector3.eulerAngles(vector: direction)
        
        return node
    }
}

class ARViewController : UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var lines: [Line?] = []
    
    var room : Room? = nil
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
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
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        //let line = SCNNode.line(from: SCNVector3(x: 0, y: 0, z: 0), to: SCNVector3(x: -4, y: 1, z: 2))

        for line in lines
        {
            let node = SCNNode.line(from: SCNVector3(x: (line?.start.x)!, y: (line?.start.y)!, z: (line?.start.z)!), to: SCNVector3(x: (line?.end.x)!, y: (line?.end.y)!, z: (line?.end.z)!))
            node.geometry?.firstMaterial?.diffuse.contents = line?.color
            sceneView.scene.rootNode.addChildNode(node)
        }
        
    }
    
    func loadLines()
    {
        let linequery = PFQuery(className: "Line")
        
        linequery.whereKey("roomId", contains: self.room!.id)
        //linequery.whereKey("roomnumber", contains: String(self.room!.number))
        linequery.findObjectsInBackground ( block: { (lines, error) in
            if error == nil {
                for line in lines! {
                    self.lines.append(Line(start: Point(x: line["StartX"] as! Float, y: line["StartY"] as! Float, z: line["StartZ"] as! Float), end: Point(x: line["EndX"] as! Float, y: line["EndY"] as! Float, z: line["EndZ"] as! Float), color: line["Color"] as! String))
                }
            }
        })
    }
}
