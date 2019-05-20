//
//  GameScene.swift
//  PingPong
//
//  Created by Tomozi Peter on 2019. 05. 14..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let emptyZone:CGFloat = 100.0
    let racketSize:CGSize = CGSize(width: 100, height: 30)
    lazy var player:Racket = {
       let racket = Racket(color: UIColor.red, size: racketSize)
       racket.setup(owner: .player)
       racket.position = CGPoint(x: size.width/2, y: emptyZone)
       return racket
    }()
    lazy var opponent:Racket = {
        let racket = Racket(color: UIColor.red, size: racketSize)
        racket.setup(owner: .opponent)
        racket.position = CGPoint(x: size.width/2, y: size.height-emptyZone+15)
        return racket
    }()
    lazy var backgroundImage:SKSpriteNode = {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: size.width, height: size.height )
        background.zPosition = -2
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        return background
    }()
    lazy var playerScore:ScoreLabel = {
        let label = ScoreLabel(type: .player)
        label.label.position = CGPoint(x: 180.0, y: 40)
        label.label.zPosition = 1
        return label
    }()
    lazy var ball: Ball = {
        let ball = Ball()
        let center = CGPoint(x: size.width/2, y: size.height/2)
        ball.position = center
        return ball
    }()
    lazy var lifeLabel: PlayerLife = {
        let life = PlayerLife(5)
        life.label.position = CGPoint(x: size.width - 80, y: 40)
        life.label.zPosition = 1
        return life
    }()
    var playerX: CGFloat {
        get {
            return player.position.x
        }
        set(x) {
            var newX: CGFloat = x
            if x < racketSize.width {
                newX = racketSize.width
            } else if newX > size.width-racketSize.width {
                newX = size.width-racketSize.width
            }
            player.position.x = newX
        }
    }
    var opponentX: CGFloat {
        get {
            return opponent.position.x
        }
        set(x) {
            var newX: CGFloat = x
            if x < racketSize.width {
                newX = racketSize.width
            } else if newX > size.width-racketSize.width {
                newX = size.width-racketSize.width
            }
            opponent.position.x = newX
        }
    }
    lazy var startGameLabel: SKLabelNode = {
        let label = SKLabelNode(text: "touch screen to start new game")
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: size.width/2, y: size.height/2+50)
        label.fontSize = 38
        label.fontColor = UIColor.red
        label.zPosition = -3
        return label
    }()
    lazy var endGameLabel: SKLabelNode = {
        let label = SKLabelNode(text: "your score: \(playerScore.score)")
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: size.width/2, y: size.height/2-50)
        label.fontSize = 38
        label.fontColor = UIColor.red
        label.zPosition = -3
        return label
    }()
    
    var ballDirectonTo: RacketOwner?
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        addChild(backgroundImage)
        addChild(player)
        addChild(opponent)
        addChild(playerScore.label)
        addChild(lifeLabel.label)
        addChild(ball)
        addChild(startGameLabel)
        addChild(endGameLabel)
        
        waitForStartGame()
    }
    
    var gameState :GameState = .waitToStart
    
    func startGame() {
        startGameLabel.zPosition = -4
        endGameLabel.zPosition = -4
        gameState = .process
        skillLevel = 5
        contactLevel = 0
        playerScore.score = 0
        playerLife = 5
        player.position = CGPoint(x: size.width/2, y: emptyZone)
        opponent.position = CGPoint(x: size.width/2, y: size.height-emptyZone+15)
        startBall()
    }
    func startBall() {
        ball.position = CGPoint(x: size.width/2, y: size.height/2)
        var angle = CGFloat()
        if Bool.random() {
            angle = GameLogic.randomCGFloat(CGFloat.pi*1/4, CGFloat.pi*3/4)
        } else {
            angle = GameLogic.randomCGFloat(-CGFloat.pi*1/4, -CGFloat.pi*3.4)
        }
        let speed:CGFloat = 400
        
        ball.physicsBody?.velocity = GameLogic.getVector(withSpeed: speed, withAngle: angle)
    }
    
    func endGame() {
        endGameLabel.zPosition = 3
        endGameLabel.text = "your score: \(playerScore.score)"
        waitForStartGame()
    }
    func waitForStartGame() {
        startGameLabel.zPosition = 2
        gameState = .waitToStart
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        //player,oppenent,ball
        let sortedNodes = [nodeA,nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        
        if sortedNodes[1].name == RacketOwner.player.rawValue {
            contactLevel += 1
            playerScore.score += 1
            if contactLevel % 10 == 0 {
                //növeljük a labda sebességét
                ball.physicsBody?.velocity.dy += 2
                skillLevel += 1
            }
            ballDirectonTo = RacketOwner.opponent
        } else if sortedNodes[1].name == RacketOwner.opponent.rawValue {
            ballDirectonTo = RacketOwner.player
        }
        setBallVector(sortedNodes[1])
    }
    func setBallVector(_ node:SKNode) {
        var delta: CGFloat = 10
        if node.name == RacketOwner.opponent.rawValue {
            delta = 20 + skillLevel
        }
        delta = GameLogic.randomCGFloat(-delta, delta)
        ball.physicsBody?.velocity.dx += delta
    }
    
    var skillLevel:CGFloat = 5
    var contactLevel:Int = 0
    var playerLife:Int = 5 {
        didSet {
            lifeLabel.life = playerLife
        }
    }
    
    override func didSimulatePhysics() {
        //Tells your app to peform any necessary logic after physics simulations are performed.
        if gameState == .waitToStart {
            return
        }
        if ball.position.x <= 70 || ball.position.x >= size.width-70 {
            ball.physicsBody?.velocity.dx *= -1
        }
        
        if ball.position.x >= opponentX {
            opponentX +=  skillLevel
        } else {
            opponentX -= skillLevel
        }
        if ball.position.y >= size.height {
            playerScore.score += 100
            startBall()
        } else if ball.position.y <= 0 {
            if playerLife == 1 {
                playerLife = 0
                endGame()
            } else {
                playerLife -= 1
                startBall()
            }
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .waitToStart {
            startGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .waitToStart {
           startGame()
        } else {
           for touch in touches {
                let location = touch.location(in: self)
                playerX = location.x
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
