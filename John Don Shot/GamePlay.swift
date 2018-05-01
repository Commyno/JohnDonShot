//
//  GamePlay.swift
//  John Don Shot
//
//  Created by Giovanni on 13/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import SpriteKit

class Gameplay: SKScene {
    
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

    lazy var returnButton: JDButton = {
        var button = JDButton(imageNamed: "ButtonBack", buttonAction: {
            self.returnToMainMenu()
        })
        button.scaleTo(screenWithPercentage: 0.1)
        button.zPosition = 1
        return button
    }()

    // Variabili
    var gameinfo = GameInfo.shared

    override func didMove(to view: SKView) {
        print("---GamePlay--")
        
        // Rimuovo tutte le precedenti View
        removeUIViews()

        anchorPoint = CGPoint(x: 0.0, y: 0.0)

        setupNodes()
        addNodes()
        loadgameinfo()

        gameinfo.changeGameState(.Start)

    }
    
    func setupNodes() {
        // Title
        title.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.heigth * 0.96)
        returnButton.position = CGPoint(x: ScreenSize.width * 0.05, y: ScreenSize.heigth * 0.96)
    }

    func addNodes() {
        addChild(title)
        addChild(returnButton)
    }
    
    func loadgameinfo() {
        
        let check = gameinfo.load(scene: self)
        
        if(!check.0){
            print("LOADING ERROR: ", check.1)
            return
        }

    }

    func returnToMainMenu() {
        JDSManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.moveIn(with: .right, duration: 0.5))
    }

    
}
