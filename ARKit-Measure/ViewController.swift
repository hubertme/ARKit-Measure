//
//  ViewController.swift
//  ARKit-Measure
//
//  Created by Hubert Wang on 18/01/19.
//  Copyright © 2019 Hubert Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var spheres: [SCNNode] = []
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Adding Sphere
//        let position = SCNVector3(0, 0, -3)
//        let sphereNode = createSphere(at: position)
//        scene.rootNode.addChildNode(sphereNode)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUserTap))
        tapGesture.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleUserTap(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(location, types: [.featurePoint])
        guard let result = hitTest.last else {return}
        
        let transform = SCNMatrix4.init(result.worldTransform)
        let vector = SCNVector3Make(transform.m41, transform.m42, transform.m43)
        let sphere = createSphere(at: vector)
        spheres.append(sphere)
        
        if let first = spheres.first {
            print(sphere.distance(to: first))
            if spheres.count > 2 {
                for sphere in spheres {
                    sphere.removeFromParentNode()
                }
                spheres = [spheres[2]]
            }
        }
        
        for sphere in spheres {
            self.sceneView.scene.rootNode.addChildNode(sphere)
        }
    }
    
    private func createSphere(at position: SCNVector3) -> SCNNode{
        let sphere = SCNSphere(radius: 0.005)
        let node = SCNNode(geometry: sphere)
        node.position = position
        
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "mars_texture.png")
        sphere.firstMaterial = material
        
        return node
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
