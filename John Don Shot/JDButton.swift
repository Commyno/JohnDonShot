//
//  JDButton.swift
//  John Don Shot
//
//  Created by Giovanni on 13/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import SpriteKit

class JDButton: SKNode {
    var button: SKSpriteNode
    private var mask: SKSpriteNode
    private var cropNode: SKCropNode
    private var action: () -> Void
    private var inOrOut: Bool = true
    private var buttonSize: CGSize = CGSize.zero
    var isEnabled = true
    var titleLabel: SKLabelNode?
    
    init(imageNamed: String, title: String? = "", buttonAction: @escaping () -> Void) {
        button = SKSpriteNode(imageNamed: imageNamed)
        titleLabel = SKLabelNode(text: title)
        buttonSize = button.size

        mask = SKSpriteNode(color: SKColor.black, size: button.size)
        mask.alpha = 0
        
        cropNode = SKCropNode()
        cropNode.maskNode = button
        cropNode.zPosition = 3
        cropNode.addChild(mask)
        
        action = buttonAction
        
        super.init()
        
        isUserInteractionEnabled = true
        
        setupNodes()
        addNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNodes() {
        button.zPosition = 0
        
        if let titleLabel = titleLabel {
            titleLabel.fontName = "Arial-BoldMT"
            titleLabel.fontSize = CGFloat.universalFont(size: 24)
            titleLabel.fontColor = SKColor.white
            titleLabel.zPosition = 1
            titleLabel.horizontalAlignmentMode = .center
            titleLabel.verticalAlignmentMode = .center
        }
    }
    
    func addNodes() {
        addChild(button)
        if let titleLabel = titleLabel {
            addChild(titleLabel)
        }
        addChild(cropNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            mask.alpha = 0.5
            run(SKAction.scale(by: 1.05, duration: 0.05))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location: CGPoint = touch.location(in: self)
                
                if button.contains(location) {
                    mask.alpha = 0.5
                    if !inOrOut {
                        run(SKAction.scale(by: 1.05, duration: 0.05))
                    }
                    inOrOut = true
                } else {
                    mask.alpha = 0.0
                    if inOrOut {
                        run(SKAction.scale(to: buttonSize, duration: 0.05))
                    }
                    inOrOut = false
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location: CGPoint = touch.location(in: self)
                
                if button.contains(location) {
                    let fileToPlay: [String : FileToPlay] = ["FileToPlay":FileToPlay(filename: "TapSound", estensione: "mp3", numberOfLoops: 0)]
                    NotificationCenter.default.post(name:startSoundEffectNotificationName, object: nil, userInfo:fileToPlay)
                    disable()
                    action()
                    run(SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.run({
                        self.enable()
                    })]))
                }
            }
            run(SKAction.scale(to: buttonSize, duration: 0.05))
        }
    }
    
    func disable() {
        isEnabled = false
        mask.alpha = 0.0
        button.alpha = 1.0
    }
    
    func enable() {
        isEnabled = true
        mask.alpha = 0.0
        button.alpha = 1.0
    }
    
    func logAvailableFonts() {
        for family: String in UIFont.familyNames {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("==\(names)")
            }
        }
    }
    
    func scaleTo(screenWithPercentage: CGFloat) {
        let aspectRatio = button.size.height / button.size.width
        let screenWidth = ScreenSize.width
        var screenHeight = ScreenSize.heigth
        if DeviceType.isiPhoneX {
            screenHeight -= 80.0
        }
        button.size.width = screenWidth * screenWithPercentage
        button.size.height = button.size.width * aspectRatio
    }
    
}
