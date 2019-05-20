//
//  racket.swift
//  PingPong
//
//  Created by Tomozi Peter on 2019. 05. 14..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit

enum RacketOwner: String {
    case player
    case opponent
}

class Racket: SKSpriteNode {
    
    var currentImage: UIImage!
    
    func setup(owner rocketOwner:RacketOwner) {
        name = rocketOwner.rawValue
        switch rocketOwner {
        case .player:
            currentImage = drawPlayer(size: size)
            
        case .opponent:
            currentImage = drawOpponent(size: size)
            
        }
        texture = SKTexture(image: currentImage)
        
        physicsBody = SKPhysicsBody(rectangleOf:  size)
        physicsBody?.isDynamic  = false
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = true
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        physicsBody?.friction = 0.5
        physicsBody?.restitution = 1.0
        physicsBody?.categoryBitMask = BitMask.Racket
        physicsBody?.collisionBitMask = BitMask.Ball
        physicsBody?.contactTestBitMask = BitMask.Ball
    }
    
    func drawPlayer(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            //Color assets
            let color = UIColor.blue
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            color.setFill()
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
        }
        return image
    }
    func drawOpponent(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            //Color assets
            let color = UIColor.red
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            color.setFill()
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
        }
        return image
    }
    
}
