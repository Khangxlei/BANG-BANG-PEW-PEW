//
//  RestartScene.swift
//  spaceship_game
//
//  Created by Khang Le on 4/26/22.
//

import SpriteKit
class RestartScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.width/2)
        background.zPosition = 0
        self.addChild(background)
        
        let loadingLabel = SKLabelNode(fontNamed: "Hey Comic")
        loadingLabel.text = "Loading..."
        loadingLabel.fontColor = SKColor.white
        loadingLabel.fontSize = 125
        loadingLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.5)
        loadingLabel.zPosition = 1
        self.addChild(loadingLabel)
        
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let Transition = SKTransition.fade(withDuration: 2)
        self.view!.presentScene(sceneToMoveTo, transition: Transition)
        
    }
}
