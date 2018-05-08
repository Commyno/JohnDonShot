//
//  GamePlay.swift
//  John Don Shot
//
//  Created by Giovanni on 13/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import SpriteKit

class Gameplay: SKScene, SKPhysicsContactDelegate{
    
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

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(recognizer:)))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))

        self.view?.addGestureRecognizer(panGestureRecognizer)
        self.view?.addGestureRecognizer(tapGestureRecognizer)

        // Setting up delegate for Physics World & Set up gravity
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)

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
        
        // Player
    }

    func addNodes() {
        addChild(title)
        addChild(returnButton)

        // Add Player
        //self.addChild(gameinfo.getCurrentCharacterNode())

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

    @objc func handleTapFrom(recognizer : UITapGestureRecognizer) {
        if recognizer.state == .began {
            print("Start")
            
        // ENDED
        } else if recognizer.state == .ended {
            print("End")
            
        // CANCELLED
        } else if recognizer.state == .cancelled{
            
            print ("FAILED CANCEL")
            
        // FAILED
        } else if recognizer.state == .failed{
            print ("FAILED")
        }
    }
    @objc func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        
        let player = gameinfo.getCurrentCharacterNode()

        // BEGAN
        if recognizer.state == .began {
            //print("Start")
        // CHANGE
        } else if recognizer.state == .changed {
            let locomotion = recognizer.translation(in: recognizer.view)
            player.position.x = player.position.x + locomotion.x * 2.0

            recognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            if (player.position.x < 0 ){
                player.position.x = 0
            }
            else if (player.position.x > ScreenSize.width){
                player.position.x = ScreenSize.width
            }
            
            if (locomotion.x < -1){
                //player.run(SKAction.rotate(toAngle: 0.0872665, duration: 0.1))
            }
            else if (locomotion.x > 0.5){
                //player.run(SKAction.rotate(toAngle: -0.0872665, duration: 0.1))
            }
            else if (locomotion.x == 0.0){
                //player.run(SKAction.rotate(toAngle: 0, duration: 0.1))
            }

        // ENDED
        } else if recognizer.state == .ended {
            //print("End")
            //player.run(SKAction.rotate(toAngle: 0, duration: 0.1))

        // CANCELLED
        } else if recognizer.state == .cancelled{

            print ("FAILED CANCEL")

        // FAILED
        } else if recognizer.state == .failed{
            print ("FAILED")
        }
    }
}
