//
//  GameOver.swift
//  John Don Shot
//
//  Created by Giovanni on 13/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import SpriteKit
import StoreKit

class GameOver: SKScene {
    
    var background: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "Background")
        if DeviceType.isiPad || DeviceType.isiPadPro {
            sprite.scaleTo(screenWidthPercentage: 1.0)
        } else {
            sprite.scaleTo(screenHeightPercentage: 1.0)
        }
        sprite.zPosition = 0
        return sprite
    }()
    
    var gameOverSprite: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "GameOver")
        if DeviceType.isiPad || DeviceType.isiPadPro {
            sprite.scaleTo(screenWidthPercentage: 1.0)
        } else {
            sprite.scaleTo(screenHeightPercentage: 1.0)
        }
        sprite.zPosition = 0
        return sprite
    }()
    
    var title: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.fontSize = CGFloat.universalFont(size: 28)
        label.zPosition = 2
        label.color = SKColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "Game Over"
        return label
    }()
    
    lazy var backButton: JDButton = {
        var button = JDButton(imageNamed: "ButtonBack", title: "", buttonAction: {
            JDSManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.moveIn(with: .left, duration: 0.5))
        })
        button.zPosition = 1
        button.scaleTo(screenWithPercentage: 0.15)
        return button
    }()
    
    lazy var replayButton: JDButton = {
        var button = JDButton(imageNamed: "ButtonReplay", buttonAction: {
            
            JDSManager.shared.transition(self, toScene: .Gameplay, transition: SKTransition.moveIn(with: .left, duration: 0.5))
            
        })
        button.scaleTo(screenWithPercentage: 0.27)
        button.zPosition = 1
        return button
    }()
    
    var gameinfo = GameInfo.shared
    
    override func didMove(to view: SKView) {
        print("---GameOver--")
        
        SKStoreReviewController.requestReview()
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        setupNodes()
        addNodes()
    }
    
    func setupNodes() {
        background.position = CGPoint.zero
        gameOverSprite.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * 0.4)
        //title.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * 0.25)
        backButton.position = CGPoint(x: ScreenSize.width * -0.4, y: ScreenSize.heigth * 0.4)
        replayButton.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * -0.10)
    }
    
    func addNodes() {
        addChild(background)
        addChild(gameOverSprite)
        //addChild(title)
        addChild(backButton)
        addChild(replayButton)
    } 
    
}
