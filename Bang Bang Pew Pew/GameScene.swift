//
//  GameScene.swift
//  spaceship_game
//
//  Created by Khang Le on 4/21/22.
//

import SpriteKit
import GameplayKit

var gameScore = 0;

let buttonClick = SKAction.playSoundFileNamed("button_click.wav", waitForCompletion: false)

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    //let playBulletSound = SKAction.playSoundFileNamed("bullet.wav", waitForCompletion: false)
    let playExplosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    var level = 0;
    let scoreLabel = SKLabelNode(fontNamed: "PixelHigh")
    let restartLbl = SKLabelNode(fontNamed: "PixelHigh")
    
    var powerUp = false
    
    let player = SKSpriteNode(imageNamed: "ship")
    
    let startLabel = SKLabelNode(fontNamed: "PixelHigh")
    
    var touchingScreen = true
    
    enum gameState {
        case preGame
        case duringGame
        case postGame
    }
    
    var currentGameState = gameState.preGame
    
    struct PhysicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1
        static let Bullet: UInt32 = 0b10
        static let Enemy: UInt32 = 0b100
    }
    
    var gameArea: CGRect
    
    
    
    override init(size: CGSize){
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
            
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
    
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1 {
            let background = SKSpriteNode(imageNamed:"background" )
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }
        
        
        
        player.setScale(8)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 150
        
        scoreLabel.fontColor = SKColor.orange
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        scoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        
        
        restartLbl.text = "⏻"
        restartLbl.fontSize = 110
        restartLbl.fontColor = SKColor.red
        restartLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        restartLbl.position = CGPoint(x: self.size.width*0.25, y: self.size.height*0.9)
        restartLbl.zPosition = 100
        self.addChild(restartLbl)
        
        if currentGameState == gameState.preGame {
            startLabel.text = "Tap To Begin"
            startLabel.fontSize = 100
            startLabel.zPosition = 100
            startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            startLabel.fontColor = SKColor.white
            self.addChild(startLabel)
        }
        
    }
        
    func addScore(){
        gameScore += 1
        let scoreLvl2 = 25
        let scoreLvl3 = 40
        scoreLabel.text = "Score : \(gameScore)"
        
        if gameScore == 200 {
            EndGame()
        }
        
        if gameScore == scoreLvl2 || gameScore == scoreLvl3 {
            startNewLevel()
        }
    }
    
    func gameOver(){
        currentGameState = gameState.postGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet") {
            bullet, stop in
            
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        touchingScreen = false
        
        let changeScene = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let sceneChangeSequence = SKAction.sequence([waitToChangeScene, changeScene])
        
        self.run(sceneChangeSequence)
    }
    
    func EndGame(){
        
        currentGameState = gameState.postGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet") {
            bullet, stop in
            
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        touchingScreen = false
        
        let changeScene = SKAction.run(ChangeToEndScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let sceneChangeSequence = SKAction.sequence([waitToChangeScene, changeScene])
        
        self.run(sceneChangeSequence)
    }
    
    func RestartGame(){
        currentGameState = gameState.postGame
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet") {
            bullet, stop in
            
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        touchingScreen = false
        
        let changeScene = SKAction.run(ChangeToRestartScene)
        let waitToChangeScene = SKAction.wait(forDuration: 0.25)
        let sceneChangeSequence = SKAction.sequence([waitToChangeScene, changeScene])
        
        self.run(sceneChangeSequence)
    }
    
    func ChangeToRestartScene(){
        let sceneToMoveTo = RestartScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let Transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: Transition)
    }
    
    func ChangeToEndScene(){
        let sceneToMoveTo = EndGameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let Transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: Transition)
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let Transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: Transition)

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var b1 = SKPhysicsBody()
        var b2 = SKPhysicsBody()
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            b1 = contact.bodyA
            b2 = contact.bodyB
        }
        else {
            b1 = contact.bodyB
            b2 = contact.bodyA
        }
        
        if b1.categoryBitMask == PhysicsCategories.Bullet && b2.categoryBitMask == PhysicsCategories.Enemy{
            
            if b2.node != nil {
                if b2.node!.position.y > self.size.height {
                    return
                }
                Explosion(spawnPosition: b2.node!.position)
                addScore()
            }
            b1.node?.removeFromParent()
            b2.node?.removeFromParent()
            
        }
        
        if b1.categoryBitMask == PhysicsCategories.Player && b2.categoryBitMask == PhysicsCategories.Enemy{
        
            
            if b1.node != nil && b2.node != nil {
                Explosion(spawnPosition: b1.node!.position)
                Explosion(spawnPosition: b2.node!.position)
            }
            b1.node?.removeFromParent()
            b2.node?.removeFromParent()
            
            gameOver()
        }
    }
    
    func Explosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.setScale(8)
        explosion.position = spawnPosition
        explosion.zPosition = 3
        self.addChild(explosion)
        
        let scaleBigger = SKAction.scale(to: 8, duration: 0.15)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let deleteExplosion = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([playExplosionSound, scaleBigger, fadeOut, deleteExplosion])
        explosion.run(explosionSequence)
        
    }
    
    func startNewLevel(){
        
        level += 1
        
        let removeLabel = SKAction.removeFromParent()
        startLabel.run(removeLabel)
        
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        var enemySpeed = Double(3)
        
        if level == 1 {
            levelDuration = 1.2
            enemySpeed = 2.0
        }
        else if level == 2 {
            levelDuration = 0.75
            enemySpeed = 1
        }
        else if level == 3 {
            levelDuration = 0.65
            enemySpeed = 0.75
            powerUp = true
        }
        else {
            levelDuration = 0.3
            enemySpeed = 1;
            print("Level is invalid")
        }
        
        let spawn = SKAction.run({self.spawnEnemy(spawnSpeed: Double(enemySpeed))})
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawnEnemies")
    }
    
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(6)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 0.3)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    func spawnEnemy(spawnSpeed: Double){
        let XSpawn = CGFloat.random(in: -(gameArea.minX*2)...(gameArea.maxX)*1.45)
        let XDespawn = CGFloat.random(in: gameArea.minX + (player.size.width*2)...gameArea.maxX - (player.size.width*2) )
        
        let startPoint = CGPoint(x: XSpawn, y: self.size.height*1.2)
        let endPoint = CGPoint (x: player.position.x, y: -self.size.height * 0.2)
        
        
        //let XDespawn = CGFloat.random(in: gameArea.minX...gameArea.maxX)
        //let YDespawn = CGFloat.random(in: gameArea.minY...gameArea.maxY*0.1)
        
        let enemy = SKSpriteNode(imageNamed:"meteor")
        enemy.name = "Enemy"
        enemy.setScale(6)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: TimeInterval(spawnSpeed))
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        
        if currentGameState == gameState.duringGame {
            enemy.run(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let degreeRotation = atan2(dy,dx)
        enemy.zRotation = degreeRotation
    }
    
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = true
        
        if currentGameState == gameState.preGame {
            currentGameState = gameState.duringGame
            startNewLevel()
        }
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            //turns this into a button, restartLabel will recognize when user touches on it
            if restartLbl.contains(pointOfTouch) {
                restartLbl.run(buttonClick)
                RestartGame()
                
            }
        }
    }
    
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = false
    }
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    override func update(_ currentTime: TimeInterval) {
        
        if touchingScreen == true && currentGameState == gameState.duringGame{
            fireBullet()
        }
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
            
        }
        else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background") {
            background, stop in
            
            background.position.y -= amountToMoveBackground
            
            if background.position.y < -self.size.height {
                background.position.y += self.size.height*2
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointofTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            
            let distancex = pointofTouch.x - previousPointOfTouch.x
            let distancey = pointofTouch.y - previousPointOfTouch.y
                
            player.position.x += distancex
            player.position.y += distancey
            
            
            if (player.position.x < gameArea.minX + (player.size.width*2)){
                player.position.x = gameArea.minX + (player.size.width*2)
            }
      
            if (player.position.x > gameArea.maxX - (player.size.width*2)){
                player.position.x = gameArea.maxX - (player.size.width*2)
            }
            
            if player.position.y < gameArea.minY + (player.size.height*2){
                player.position.y = gameArea.minY + (player.size.height*2)
            }
            
            if player.position.y > gameArea.maxY - player.size.height*2 {
                player.position.y = gameArea.maxY - player.size.height*2
            }
        }
    }
}
