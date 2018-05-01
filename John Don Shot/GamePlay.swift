//
//  GamePlay.swift
//  John Don Shot
//
//  Created by Giovanni on 13/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import SpriteKit

class Gameplay: SKScene {
    
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
    
    var title: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.fontSize = CGFloat.universalFont(size: 24)
        label.zPosition = 2
        label.color = SKColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "John Don Shot"
        return label
    }()

    // Variabili
    var gameinfo = GameInfo.shared

    override func didMove(to view: SKView) {
        print("---GamePlay--")
        
        // Rimuovo tutte le precedenti View
        removeUIViews()

        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        loadBackground()
        loadgameinfo()

    }
    
    func loadBackground() {
        
        // Background
        background.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.heigth * 0.5)
        
        // Title
        title.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.heigth * 0.5)
        //title.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * 0.25)

        addChild(background)
        addChild(title)
    }
    
    func loadgameinfo() {
        
        let check = gameinfo.load(scene: self)
        
        if(!check.0){
            print("LOADING ERROR: ", check.1)
            return
        }

    }

    
}
