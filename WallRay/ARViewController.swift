//
//  ARViewController.swift
//  WallRay
//
//  Created by Felix Ohlsen on 31.05.18.
//  Copyright © 2018 Fritz Oppelt. All rights reserved.
//

import Foundation
import ARKit

class ARViewController : UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (ARConfiguration.isSupported) {
            print("Supported")// ARKit is supported. You can work with ARKit
        } else {
            print("Not supported")
            // ARKit is not supported. You cannot work with ARKit
        }
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
