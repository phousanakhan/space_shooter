//
//  GameOverScene.swift
//  space_shooter
//
//  Created by Phousanak Han on 18/06/20.
//  Copyright © 2020 Phousanak Han. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameplayKit

class GameOverScene: SKScene{
    let restartLebel = SKLabelNode(fontNamed: "THe Bold Font")

    override func didMove(to view: SKView) {
        
        /*let background = SKSpriteNode(imageNamed: "back1")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)*/
        for i in 0...1{
            let background = SKSpriteNode(imageNamed: "back1")
            //take the background size = same size as the current scene
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            //to get center point
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            //take info above and make background
            self.addChild(background)
        }

        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 150
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.65)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let ScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        ScoreLabel.text = "SCORE: \(gameScore)"
        ScoreLabel.fontSize = 100
        ScoreLabel.fontColor = SKColor.white
        ScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        ScoreLabel.zPosition = 1
        self.addChild(ScoreLabel)
        
        let defaults = UserDefaults()
        var HighScore = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > HighScore {
            HighScore = gameScore
            defaults.set(HighScore, forKey: "highScoreSaved")
        }
        
        let HighScoreLabel = SKLabelNode(fontNamed: "THe Bold Font")
         HighScoreLabel.text = "HIGH SCORE: \(HighScore)"
         HighScoreLabel.fontSize = 70
         HighScoreLabel.fontColor = SKColor.white
         HighScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
         HighScoreLabel.zPosition = 1
         self.addChild(HighScoreLabel)
        
        //let restartLebel = SKLabelNode(fontNamed: "THe Bold Font")
        restartLebel.text = "RESTART"
        restartLebel.fontSize = 50
        restartLebel.fontColor = SKColor.white
        restartLebel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.35)
        restartLebel.zPosition = 1
        self.addChild(restartLebel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            if restartLebel.contains(pointOfTouch) {
        
                let sceneMoveTo = GameScene(size: self.size)
                sceneMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneMoveTo, transition: myTransition)
            }
            
        }
    }
    
    var LastUpdateTime: TimeInterval = 0
    var deltaFrame: TimeInterval = 0
    var amountMovePerSec: CGFloat = 700.0
    
    override func update(_ currentTime: TimeInterval) {
        if LastUpdateTime == 0{
            LastUpdateTime = currentTime
        }
        else{
            deltaFrame = currentTime - LastUpdateTime
            LastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountMovePerSec * CGFloat(deltaFrame)
        self.enumerateChildNodes(withName: "Background") {
            (background, stop) in
            background.position.y -= amountToMoveBackground
            
            if background.position.y < -self.size.height{
                background.position.y += self.size.height * 2
            }
        }
        
    }
}
