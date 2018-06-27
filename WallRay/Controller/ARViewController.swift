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

// Vector calculations
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

// Extensions for the SCNVector3 class
extension SCNVector3
{
    // Get vector length
    func length() -> Float {
        return sqrtf(x*x + y*y + z*z)
    }
    
    // Calculate the eulerAngle for the rotation between two points
    static func eulerAngles(vector: SCNVector3) -> SCNVector3 {
        // Cylinder height
        let height = vector.length()
        
        // Length of X and Z
        let lengthXZ = sqrtf(vector.x * vector.x + vector.z * vector.z)
       
        var tempXRotation: Float = 0
        var xRotation: Float = 0
        
        if(vector.y < 0)
        {
            // PI - asin from lengthXZ/height
            tempXRotation = Float.pi - asinf(lengthXZ/height)
        }
        else
        {
            // asin from lengthXZ/height
            tempXRotation = asinf(lengthXZ/height)
        }
        
        // If z is below 0 multiply with -1
        if(vector.z >= 0)
        {
            xRotation = tempXRotation
        }
        else
        {
            xRotation = -1 * tempXRotation
        }
        
        var yRotation: Float = 0
        
        if(vector.x != 0 || vector.z != 0)
        {
            let temp = vector.x / (height * sinf(lengthXZ))
            
            if(temp > 1 || temp < -1)
            {
                yRotation = Float.pi / 2
            }
            else
            {
                yRotation = asinf(temp)
            }
        }
        
        // Return the x and y rotations
        return SCNVector3(CGFloat(xRotation), CGFloat(yRotation), 0)
    }
}

// Extensions for SCNNode
extension SCNNode {
    static func line(from: SCNVector3, to: SCNVector3) -> SCNNode {
        // Get direction vector
        let direction = to - from
        
        // Get distance between both points
        let distance = direction.length()
        
        // Create cylinder with the distance as length
        let cylinder = SCNCylinder(radius: 0.01, height: CGFloat(distance))
        cylinder.radialSegmentCount = 4
        
        // Create a node from the cylinder
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
    
    /**
     * Executed after view loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }

    /**
     * Executed before view loads
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (ARConfiguration.isSupported) {
            print("Supported")// ARKit is supported. You can work with ARKit
        } else {
            print("Not supported")
            // ARKit is not supported. You cannot work with ARKit
        }
        
        // Debug options for the AR View
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        // Set config to session and sets light
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        
        // Load lines from database
        //loadLines()
        
        self.title = String(self.room!.number)
    }
    
    /**
     * Executed when app receives memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * Renders 1 frame for the Scene
     */
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // Render every line in the array
        for line in (self.room?.lines)!
        {
            // Create a line
            let node = SCNNode.line(from: SCNVector3(x: (line.start.x), y: (line.start.y), z: (line.start.z)), to: SCNVector3(x: (line.end.x), y: (line.end.y), z: (line.end.z)))
            
            // Set the color
            node.geometry?.firstMaterial?.diffuse.contents = line.color
            
            // Add node to the scene
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    /**
     * Loads line for the room from the database
     */
    func loadLines()
    {
        // Load lines with roomId as key
        let linequery = PFQuery(className: "Line")
        linequery.whereKey("roomId", contains: self.room!.id)
        linequery.findObjectsInBackground ( block: { (lines, error) in
            if error == nil {
                for line in lines! {
                    // Add line to the array
                    self.lines.append(Line(start: Point(x: line["StartX"] as! Float, y: line["StartY"] as! Float, z: line["StartZ"] as! Float), end: Point(x: line["EndX"] as! Float, y: line["EndY"] as! Float, z: line["EndZ"] as! Float), color: line["Color"] as! String))
                }
            }
        })
    }
}
