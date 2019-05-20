//
//  PlayerLife.swift
//  PingPong
//
//  Created by Tomozi Peter on 2019. 05. 20..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit

class PlayerLife {
    var label:SKLabelNode = {
        let label = SKLabelNode(text: "")
        label.horizontalAlignmentMode = .right
        label.fontSize = 30
        label.zPosition = -1
        label.fontColor = UIColor.black
        return label
    }()
    var life: Int {
        didSet {
            if life > 0 {
                label.text = String(repeating: "☀︎", count: life)
            } else {
                label.text = "game over"
            }
        }
    }
    init(_ maxlife:Int) {
         life = maxlife
    }
    func decrementLife() {
        life -= 1
    }
}
