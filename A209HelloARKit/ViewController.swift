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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.debugOptions = [.showWorldOrigin,.showFeaturePoints]
        
        
//
//        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01) //新增一個 BOX
//        let material = SCNMaterial() //新增材質
//        material.diffuse.contents = UIColor.red  //材質內容為紅色
//        box.materials = [material] //把 box 的貼圖材質加進去
//        let node = SCNNode(geometry: box) //新增一個 Box
//        node.position = SCNVector3(0, 0, -0.5) //設定 node 在空間的位置
//
//
//        sceneView.scene.rootNode.addChildNode(node) //把 node 加入到目前的 scene 上
        
        
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
         }else{
             print("nothing!")
         }
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
