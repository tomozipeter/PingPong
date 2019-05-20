//
//  ScoreLabel.swift
//  PingPong
//
//  Created by Tomozi Peter on 2019. 05. 16..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import Foundation
import SpriteKit

class ScoreLabel {
    var label:SKLabelNode = {
        let label = SKLabelNode(text: "")
        label.horizontalAlignmentMode = .right
        label.fontSize = 30
        label.zPosition = -1
        label.fontColor = UIColor.black
        return label
    }()
    var labeltype: RacketOwner
    var score: Int {
        didSet {
            let name = labeltype.rawValue
            label.text = "\(name):\(score)"
        }
    }
    
    init(type racketOwner:RacketOwner) {
        labeltype = racketOwner
        score = 0
    }
}
