//
//  StartScene.swift
//  spaceship_game
//
//  Created by Khang Le on 4/27/22.
//

import Foundation
import SpriteKit

class StartScene: SKScene {
    
    let startLabel = SKLabelNode(fontNamed: "PixelHigh")
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        let appLabel1 = SKLabelNode(fontNamed: "PixelHigh")
        appLabel1.text = "BANG BANG"
        appLabel1.fontSize = 170
        appLabel1.fontColor = SKColor.white
        appLabel1.position = CGPoint(x: self.size.width/2, y: self.size.height*0.70)
        appLabel1.zPosition = 100
        self.addChild(appLabel1)
        
        let appLabel2 = SKLabelNode(fontNamed: "PixelHigh")
        appLabel2.text = "PEW PEW"
        appLabel2.fontSize = 170
        appLabel2.fontColor = SKColor.white
        appLabel2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.63)
        appLabel2.zPosition = 100
        self.addChild(appLabel2)
        
        
        let prizeLabel1 = SKLabelNode(fontNamed: "PixelHigh")
        prizeLabel1.text = "Reach 100 Points"
        prizeLabel1.fontSize = 90
        prizeLabel1.fontColor = SKColor.white
        prizeLabel1.position = CGPoint(x: self.size.width/2, y: self.size.height*0.53)
        prizeLabel1.zPosition = 100
        self.addChild(prizeLabel1)

        
        let prizeLabel2 = SKLabelNode(fontNamed: "PixelHigh")
        prizeLabel2.text = "Get A Pleasant Surprise"
        prizeLabel2.fontSize = 90
        prizeLabel2.fontColor = SKColor.white
        prizeLabel2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.48)
        prizeLabel2.zPosition = 100
        self.addChild(prizeLabel2)
        
        
        startLabel.text = "START GAME"
        startLabel.fontSize = 95
        startLabel.fontColor = SKColor.orange
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.34)
        startLabel.zPosition = 100
        startLabel.name = "startButton"
        self.addChild(startLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            //turns this into a button, restartLabel will recognize when user touches on it
            if startLabel.contains(pointOfTouch) {
                startLabel.run(buttonClick)
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                
                let Transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: Transition)
            }
        }
    }
}
