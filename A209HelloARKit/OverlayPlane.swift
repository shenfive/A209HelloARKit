//
//  OverlayPlane.swift
//  HelloAR0509
//
//  Created by 申潤五 on 2020/5/9.
//  Copyright © 2020 申潤五. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class OverlayPlane: SCNNode {

    var anchor :ARPlaneAnchor
    var planeGeometry :SCNPlane!
    
    init(anchor :ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(anchor :ARPlaneAnchor) {
        self.planeGeometry.width = CGFloat(anchor.extent.x);
        self.planeGeometry.height = CGFloat(anchor.extent.z);
        let planeNode = self.childNodes.first!
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
    }
    
    func setup() {
        self.planeGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named:"overlay_grid.png")
        self.planeGeometry.materials = [material]
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1, 0.0, 0.0)
        //向（1,0,0) 座標轉 二分之π 即 90°
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        self.addChildNode(planeNode)
    }

    
}
