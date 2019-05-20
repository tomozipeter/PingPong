//
//  Ball.swift
//  PingPong
//
//  Created by Tomozi Peter on 2019. 05. 17..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit
import Foundation

class Ball: SKNode {
    var circle = SKShapeNode()
    let radius: CGFloat = 10.0
    
    static public func BallName() -> String {
        return "Ball"
    }
    
    override init() {
        super.init()
        name = Ball.BallName()
        
        circle = SKShapeNode(circleOfRadius: radius)
        circle.fillColor = UIColor.white
        addChild(circle)
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.isDynamic  = true
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = true
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        physicsBody?.friction = 0.5
        physicsBody?.restitution = 1.0
        physicsBody?.categoryBitMask = BitMask.Ball
        physicsBody?.collisionBitMask = BitMask.Racket
        physicsBody?.contactTestBitMask = BitMask.Racket
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
