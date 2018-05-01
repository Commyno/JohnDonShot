//
//  MainMenu.swift
//  John Don Shot
//
//  Created by Giovanni on 13/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {

    // ----------------------------------------------------------------
    // Dichiarazione degli oggetti che comporranno il MainMenu
    // ----------------------------------------------------------------

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

    lazy var playButton: JDButton = {
        var button = JDButton(imageNamed: "ButtonPlay", buttonAction: {
            
             let chance = CGFloat.random(1, max: 10)
             if chance <= 5 {
                //self.showAds()
             } else {
                self.startGameplay()
             }

        })
        button.scaleTo(screenWithPercentage: 0.33)
        button.zPosition = 1
        return button
    }()
    
    lazy var settingsButton: JDButton = {
        var button = JDButton(imageNamed: "ButtonPlay", buttonAction: {
            
            self.showSettings()
            
        })
        button.scaleTo(screenWithPercentage: 0.33)
        button.zPosition = 1
        return button
    }()

    // ----------------------------------------------------------------

    // Variabili
    var gameinfo = GameInfo.shared

    // Funzioni
    override func didMove(to view: SKView) {
        print("---MainMenu--")

        // Rimuovo tutte le precedenti View
        removeUIViews()

        //NotificationCenter.default.addObserver(self, selector: #selector(self.startGameplayNotification(_:)), name: startGameplayNotificationName, object: nil)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        loadBackground()
        loadgameinfo()
    }
    
    func loadBackground() {
        
        // Background
        background.position = CGPoint.zero

        // Title
        title.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * 0.30)

        // Button
        playButton.position = CGPoint.zero
        //playButton.logAvailableFonts()
        settingsButton.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * -0.2)

        //rateButton.position = CGPoint(x: ScreenSize.width * -0.20, y: ScreenSize.heigth * -0.15)
        //shareButton.position = CGPoint(x: ScreenSize.width * 0.20, y: ScreenSize.heigth * -0.15)

        addChild(background)
        addChild(title)
        addChild(playButton)
        addChild(settingsButton)
        //addChild(rateButton)
        //addChild(shareButton)
        
        // Applica effetto pupup ai bottoni
        playButton.button.popUp()
        settingsButton.button.popUp(after: 0.2, sequenceNumber: 1)

    }
    
    func loadgameinfo() {

        if (gameinfo.getGameState() == .NoState) {
            let check = gameinfo.load(scene: self)
            
            if(!check.0){
                print("LOADING ERROR: ", check.1)
                return
            }
        }

    }

    
    @objc func startGameplayNotification(_ info:Notification) {
        startGameplay()
    }
    
    func startGameplay() {
        JDSManager.shared.transition(self, toScene: .Gameplay, transition: SKTransition.moveIn(with: .right, duration: 0.5))
    }
    func showSettings() {
        JDSManager.shared.transition(self, toScene: .SettingsMenu, transition: SKTransition.moveIn(with: .right, duration: 0.5))
    }
}
