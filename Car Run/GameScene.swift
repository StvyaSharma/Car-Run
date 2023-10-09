//
//  GameScene.swift
//  Car Run
//
//  Created by Stvya Sharma on 17/05/21.
//

import SpriteKit
import GameplayKit
import AVFoundation
import CoreData



public class GameScene: SKScene, SKPhysicsContactDelegate {
//: ### Physics
    struct PhysicsCategory{
        static let Player: UInt32 = 1
        static let Obstacles: UInt32 = 2
    }
    let player = SKShapeNode(circleOfRadius: 20)
    let obstacleSpacing: CGFloat = 800
    let cameraNode = SKCameraNode()
    let HighScoreLabel = SKLabelNode()
    let backButtonLabel = SKLabelNode()
    var highscore  = 0
//: ### Starting Function
    public func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode{
            if nodeA.fillColor != nodeB.fillColor{
                player.physicsBody?.velocity.dy = 0
                player.removeFromParent()
                score = 0
                HighScoreLabel.text = String("High Score : \(highscore)")
                backButtonLabel.text = "Back"
                scoreLabel.text = String(score)
                let colours = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.purple]
                addPlayer(colour: colours.randomElement()!)
            }
            if nodeA.fillColor == nodeB.fillColor{
                score += 1
                
                
                if highscore < score {
                    highscore = score
                }
                
                HighScoreLabel.text = String("High Score : \(highscore)")
                scoreLabel.text = String(score)
                
            }
        }
    }
//: ### Adding Player
    func addPlayer(colour: UIColor){
        player.fillColor = colour
        player.strokeColor = player.fillColor
        player.position = CGPoint(x: 0, y: -200)
        //Physics Properties
        let playerBody = SKPhysicsBody(circleOfRadius: 15)
        playerBody.mass = 1.5
        playerBody.categoryBitMask = PhysicsCategory.Player
        playerBody.collisionBitMask = 4
        player.physicsBody = playerBody
        let img = SKSpriteNode(imageNamed: "player")
        img.size = CGSize(width: 100, height: 170)
        player.addChild(img)
        //Add to scene
        addChild(player)
    }

    func addSquare(yHeight : Int, xAxis : Int){
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 80), cornerRadius: 20)
        let obstacle = SKNode()
        
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint(x: 0, y: 0)
        section.fillColor = UIColor.white
        section.strokeColor = UIColor.white
            section.zRotation = CGFloat(Double.pi / 2) * CGFloat(1);
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            //Add to Obstacle
            obstacle.addChild(section)
        let img = SKSpriteNode(imageNamed: "enemy")
        img.size = CGSize(width: 100, height: 170)
        img.position = CGPoint(x: -40, y: 80)
        obstacle.addChild(img)
        obstacle.position = CGPoint(x: xAxis, y: yHeight)
        addChild(obstacle)
        
    }

    

//: ### Circle Obstacle
    let scoreLabel = SKLabelNode()
    var score = 0
//: ### Function to add Obstacles
    func addObstacle() {
        
        var i = 200
        var lol = 0
        while lol < 100{
            let x = Int.random(in: 0...4)
            switch x {
            case 0:
                addSquare(yHeight: i, xAxis: 40)
                i += 900

            case 1:
                addSquare(yHeight: i, xAxis: 170)
                i += 900
            case 2:
                addSquare(yHeight: i, xAxis: 300)
                i += 900
            case 3:
                addSquare(yHeight: i, xAxis: -220)
                i += 900
            case 4:
                addSquare(yHeight: i, xAxis: -90)
                i += 900

            default:
                print("NUll")
            }
            lol += 1
        }
            
        
    }
    
    let colours = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.purple]
//: ### Movement of Player
    public override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy = 6
        
        addPlayer(colour: .red)
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = player.position
        scoreLabel.position = CGPoint(x: 0, y: 500)
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 100
        scoreLabel.text = String(score)
        backButtonLabel.fontColor = .white
        backButtonLabel.position = CGPoint(x: 300, y: 600)
        backButtonLabel.fontSize = 50
        backButtonLabel.fontName = "AvenirNext-Bold"
        HighScoreLabel.position = CGPoint(x:0, y:-600)
        HighScoreLabel.fontName = "AvenirNext-Bold"
        HighScoreLabel.fontSize = 50
        HighScoreLabel.fontColor = .white
        HighScoreLabel.text = String("High Score : \(highscore)")
        backButtonLabel.text = "Back"
        
        addObstacle()
       
    }
    public override func update(_ currentTime: TimeInterval) {
        let playerPositionInCamera = cameraNode.convert(player.position, to: self)
        if playerPositionInCamera.y != cameraNode.position.y && !cameraNode.hasActions(){
            cameraNode.position.y = player.position.y + 350
        }
        if player.position.y <= -750 {
            player.physicsBody?.isDynamic = true
            player.physicsBody?.velocity.dy = 1.0
        }
        player.physicsBody?.velocity.dy = 650
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if player.position.x == frame.midX {
            for touch in touches {
                let location = touch.location(in: self)
                if  location.x <= frame.midX{
                    player.position.x = player.position.x - 130
                }else if location.x >= frame.midX {
                    player.position.x = player.position.x + 130
                }
            }
        } else if player.position.x == frame.midX + 130 {
            for touch in touches {
                let location = touch.location(in: self)
                if  location.x <= frame.midX{
                    player.position.x = player.position.x - 130
                }else if location.x >= frame.midX {
                    player.position.x = player.position.x + 130
                }
            }
        } else if player.position.x == frame.midX - 130 {
            for touch in touches {
                let location = touch.location(in: self)
                if  location.x <= frame.midX{
                    player.position.x = player.position.x - 130
                }else if location.x >= frame.midX {
                    player.position.x = player.position.x + 130
                }
            }
        } else if player.position.x == frame.midX - 260 {
            for touch in touches {
                let location = touch.location(in: self)
                 if location.x >= frame.midX {
                    player.position.x = player.position.x + 130
                }
            }
        } else if player.position.x == frame.midX + 260 {
            for touch in touches {
                let location = touch.location(in: self)
                 if location.x <= frame.midX {
                    player.position.x = player.position.x - 130
                }
            }
        }

        
    }

    
}
