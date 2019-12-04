//
//  ViewController.swift
//  PocketProphet
//
//  Created by Janice Lee on 2019-11-13.
//  Copyright © 2019 Janice Lee. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ProphetImages", bundle: Bundle.main) {
            configuration.trackingImages = trackedImages
            configuration.maximumNumberOfTrackedImages = trackedImages.count
        }
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let videoNode = SKVideoNode(fileNamed: "harry.mp4")
            videoNode.play()
            
            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            videoNode.position = CGPoint(x: videoScene.size.width / 2 , y: videoScene.size.height / 2)
            videoNode.yScale = -1.0
            videoScene.addChild(videoNode)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                 height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
        }
        return node
    }
}
