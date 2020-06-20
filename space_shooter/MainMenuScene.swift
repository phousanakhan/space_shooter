//
//  MainMenuScene.swift
//  space_shooter
//
//  Created by Phousanak Han on 20/06/20.
//  Copyright © 2020 Phousanak Han. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "back1")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameTitleLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameTitleLabel.text = "Space Shooter"
        gameTitleLabel.fontSize = 150
        gameTitleLabel.fontColor = SKColor.white
        gameTitleLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        gameTitleLabel.zPosition = 1
        self.addChild(gameTitleLabel)
    }
}
