//
//  GameScene.swift
//  Space Shoot
//
//  Created by Phousanak Han on 08/05/20.
//  Copyright © 2020 Phousanak Han. All rights reserved.
//

import SpriteKit
import GameplayKit


var gameScore = 0
class GameScene: SKScene, SKPhysicsContactDelegate {
    let player = SKSpriteNode(imageNamed: "playerShip")
    let bulletSound = SKAction.playSoundFileNamed("gun_effect.mp3", waitForCompletion: false)
    

    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    var levelNumb = 0
    var LivesNumb = 3
    let LivesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    enum gameState {
        case preGame //before game
        case inGame //during game
        case afterGame //after game
    }
    var current_state = gameState.inGame
    
    
    struct PhysicsCategories{
        static let None: UInt32 =  0 //0
        static let Player: UInt32 = 0b1 //1
        static let Bullet: UInt32 = 0b10 //2
        static let Enemy: UInt32 = 0b100 //4.   4 because 3 would represent (player + bullet)
    }

    //globally declared game area as a rectangle
    let gameArea: CGRect
    var mv_ground1 = SKSpriteNode()
    var mv_ground2 = SKSpriteNode()
    var mv_ground3 = SKSpriteNode()
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    var parallax = SKAction()
    override init(size: CGSize) {
        
        let MaxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/MaxAspectRatio
        let margin = (size.width - playableWidth)/2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        gameScore = 0
        self.physicsWorld.contactDelegate = self
        
        mv_ground1 = SKSpriteNode(imageNamed: "back1")
       // mv_ground1.position = CGPoint(x: 0, y: 0)
        mv_ground1.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        mv_ground1.zPosition = 1
        //mv_ground1.size = CGSize(width: self.frame.size.width, height: 0)
        mv_ground1.size = self.size
    
        mv_ground2 = SKSpriteNode(imageNamed: "back1")
        mv_ground2.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height + mv_ground1.position.y)
        //mv_ground2.position = CGPoint(x: 0, y: self.frame.size.height)
        mv_ground2.zPosition = 1
        //mv_ground2.size = CGSize(width: self.frame.size.width, height: 0)
        mv_ground2.size = self.size
        
        mv_ground3 = SKSpriteNode(imageNamed: "back2")
        mv_ground3.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height + mv_ground2.position.y)
        //mv_ground3.position = CGPoint(x: 0, y: self.frame.size.height + mv_ground2.position.y)
        mv_ground3.zPosition = -99
        //mv_ground3.size = CGSize(width: self.frame.size.width, height: 0)
        mv_ground3.size = self.size
        
        self.addChild(mv_ground1)
        self.addChild(mv_ground2)
        self.addChild(mv_ground3)
        
        parallax = SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0, dy: -self.frame.size.height-0.5), duration: 4))
        mv_ground1.run(parallax)
        mv_ground2.run(parallax)
        mv_ground3.run(parallax)
        /*  STATIC BACKGROUND
        let background = SKSpriteNode(imageNamed: "back")
        //take the background size = same size as the current scene
        background.size = self.size
        //to get center point
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        //take info above and make background
        self.addChild(background)
        */
        
        //Set the scale of the image; eg 1 is 1:1 scale
        player.setScale(0.8)
        //height * 0.2 because we want to start 20% from the bottom of the device
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        //As long as greater than 0, will be above background
        player.zPosition = 3
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        //take info above and make the player
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.20, y: self.size.height*0.9)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        LivesLabel.text = "lives: 3"
        LivesLabel.fontSize = 50
        LivesLabel.fontColor = SKColor.white
        LivesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        LivesLabel.position = CGPoint(x: self.size.width*0.80, y: self.size.height*0.9)
        LivesLabel.zPosition = 100
        self.addChild(LivesLabel)
        
        StartNewLevel()
    }
    
    func loseAlife(){
        LivesNumb -= 1
        LivesLabel.text = "Lives: \(LivesNumb)"
        
        let ScaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let ScaleDown = SKAction.scale(to: 1, duration: 0.2)
        let ScaleSequence = SKAction.sequence([ScaleUp, ScaleDown])
        LivesLabel.run(ScaleSequence)
        
        if LivesNumb == 0{
            GameOver()
        }
    }
    
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        if gameScore == 10 || gameScore == 25 || gameScore == 50 {
            StartNewLevel()
        }
    }
    
    func GameOver () {
        /*self.enumerateChildNodes(withName: "ref_bullet") {
            (bullet, stop) in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "ref_enemy"){
            (enemy, stop) in
            enemy.removeAllActions()
        }*/
        current_state = gameState.afterGame
        self.removeAllActions()
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitChangeScene = SKAction.wait(forDuration: 0.5)
        let changeSequence = SKAction.sequence([waitChangeScene, changeSceneAction])
        //let changeSequence = SKAction.sequence([changeSceneAction])
        self.run(changeSequence)
        
        
    }
    
    func changeScene() {
        let moveTo = GameOverScene(size: self.size) //new scene
        moveTo.scaleMode = self.scaleMode
        let mv_transition = SKTransition.fade(withDuration: 1)
        self.view!.presentScene(moveTo, transition: mv_transition) //take currrent view -> remove current view -> present moveTo
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{ //grab the category# of bodyA and bodyB. If bodyA category# have a lower category#
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {//player contact with enemey
            if body1.node != nil {
            spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil {
            spawnExplosion(spawnPosition: body2.node!.position)
            }
           // body1.node?.removeFromParent() //delete player
            body2.node?.removeFromParent() //delete enemey
            if LivesNumb == 1 { //not 0 because lives deduction is done in GameOver()
                body1.node?.removeFromParent() //delete player
            }
            
            loseAlife()
        }
                
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy { //if the bullet hits the enemey
            addScore()
            
            if body2.node != nil {
                if body2.node!.position.y > self.size.height {
                    return //if the enemey is off the top of the screen ==> return. This will stop running the code here
                }
                else {
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            body1.node?.removeFromParent() //delete bullet
            body2.node?.removeFromParent() //delete enemey
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeIn(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
    }
    
    
    func StartNewLevel(){
        levelNumb += 1
        
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumb {
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1.0
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.6
        default:
            levelDuration = 1.2
            
        }
        
        let spawn = SKAction.run(Spawn_Enemy)
        let waitSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitSpawn, spawn])
        let infiniteSpawn = SKAction.repeatForever(spawnSequence)
        self.run(infiniteSpawn, withKey: "spawningEnemies")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if mv_ground1.position.y <= -self.frame.size.height {
            mv_ground1.position.y = self.frame.size.height * 1.5
        }
        if mv_ground2.position.y <= -self.frame.size.height {
            mv_ground2.position.y = self.frame.size.height * 1.5
        }
        if mv_ground3.position.y <= -self.frame.size.height {
            mv_ground3.position.y = self.frame.size.height * 1.5
        }
    }
    
    
    
    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "ref_bullet"
        bullet.setScale(0.3)
        bullet.position = player.position
        bullet.zPosition = 2
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        //bullet movement along y-axis.
        //start from player.position -> top of screen + height of bullet
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 0.7)
        //delete bullet from parent, else more bullet will pile up at top screen
        let deleteBullet = SKAction.removeFromParent()
        //allow sequence of action to be execute in the specified order
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    func Spawn_Enemy(){
        let randomX_start = random(min: gameArea.minX , max: gameArea.maxX)
        let randomX_end = random(min: gameArea.minX , max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomX_start, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomX_end, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.name = "ref_enemy"
        enemy.setScale(0.8)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None //Don't collide with anything
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet //However make contact with player or bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 3.5)
        let deleteEnemy = SKAction.removeFromParent()
      //  let loseLife = SKAction.run(loseAlife)
       // let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseLife])
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        
        if current_state == gameState.inGame{
        enemy.run(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let Rotate = atan2(dy, dx)
        enemy.zRotation = Rotate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if current_state == gameState.inGame{
        fireBullet()
        }
        //Spawn_Enemy()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let point_touch = touch.location(in: self)
            let prev_touch = touch.previousLocation(in: self)
            
            let dragged_X = point_touch.x - prev_touch.x
            let dragged_Y = point_touch.y - prev_touch.y
            
            if current_state == gameState.inGame{
            player.position.x += dragged_X
            player.position.y += dragged_Y
            }
            
            if player.position.x > gameArea.maxX - player.size.width/2{
                player.position.x = gameArea.maxX - player.size.width/2
            }
            
            if player.position.x < gameArea.minX + player.size.width/2{
                player.position.x = gameArea.minX + player.size.width/2
            }
            if player.position.y > gameArea.maxY - player.size.height/2{
                player.position.y = gameArea.maxY - player.size.height/2
            }
            
            if player.position.y < gameArea.minY + player.size.height/2{
                player.position.y = gameArea.minY + player.size.height/2
            }
            
        }
    }
}

