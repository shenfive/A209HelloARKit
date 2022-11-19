//
//  ViewController.swift
//  A209HelloARKit
//
//  Created by 申潤五 on 2022/11/19.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planes:[OverlayPlane] = []
    
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
        sceneView.debugOptions = [.showWorldOrigin,.showFeaturePoints]
            
        
        let text = SCNText(string: "Hello 申潤五", extrusionDepth: 1.0)
        text.firstMaterial?.diffuse.contents = UIColor.blue
        
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(-0.3, 0.05, -0.5)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
        
        
        let earth = SCNSphere(radius: 0.3)
        earth.firstMaterial?.diffuse.contents = UIImage(named: "worldmap")
        let earthNode = SCNNode(geometry: earth)
        earthNode.position = SCNVector3(0, 0, -1)
        sceneView.scene.rootNode.addChildNode(earthNode)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(taped(sender:)))
        sceneView.addGestureRecognizer(gesture)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    @objc func taped(sender:UIGestureRecognizer){
         let view = sender.view as! SCNView //由傳送者取得 ARView 的實體
         let location = sender.location(in: view) //取得點選的畫面座標
         let hitResult = view.hitTest(location, options: nil) //試試看能不能點到東西
         if hitResult.isEmpty != true{
             let randomColor = UIColor(
                     red: CGFloat(arc4random()) / CGFloat(UInt32.max),
                     green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                     blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
                     alpha: 1.0)
                 hitResult[0].node.geometry?.materials[0].diffuse.contents = randomColor
         }
     }

    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("find Plane")
        if !(anchor is ARPlaneAnchor) { return } //確定找到加入的是 plane
        let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor) //產出自訂義的可視平台
        self.planes.append(plane) //新增到 ViewController 的記錄中
        node.addChildNode(plane) //把自訂義的可視元件，蓋一層到平台上
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
        }.first{
            plane.update(anchor: anchor as! ARPlaneAnchor)
        }
    }



}
