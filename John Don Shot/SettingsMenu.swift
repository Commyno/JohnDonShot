//
//  Settings.swift
//  John Don Shot
//
//  Created by Giovanni on 13/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import SpriteKit

class SettingsMenu: SKScene {
    
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
        label.text = "Settaggi"
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
    
    // Settaggi
    
    lazy var musicOnOffButton: JDButton = {
        var button = JDButton(imageNamed: "ButtonMusic", buttonAction: {
            self.setMusicOnOff()
        })
        button.scaleTo(screenWithPercentage: 0.3)
        button.zPosition = 1
        return button
    }()
    
    lazy var effectOnOffButton: JDButton = {
        var button = JDButton(imageNamed: "ButtonEffect", buttonAction: {
            self.setEffectOnOff()
        })
        button.scaleTo(screenWithPercentage: 0.3)
        button.zPosition = 1
        return button
    }()

    lazy var musicSlider: JDSlider = {
        var slider = JDSlider(frame: CGRect(x: (ScreenSize.width/2)-100,
                                            y: (ScreenSize.heigth/2)-15-50,
                                            width: 200, height: 31))
        return slider
    }()

    lazy var effectSlider: JDSlider = {
        var slider = JDSlider(frame: CGRect(x: (ScreenSize.width/2)-100,
                                            y: (ScreenSize.heigth/2)-15+50,
                                            width: 200, height: 31))
        
        return slider
    }()
    
    // Variabili
    var gameinfo = GameInfo.shared

    override func didMove(to view: SKView) {
        print("---Settings--")
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        setupNodes()
        addNodes()
        setupUIControl()
        addUIControl(to: view)
        setupValori()
        addTarget()
    }

    func setupNodes() {
        background.position = CGPoint.zero
        
        // UI Object
        title.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * 0.45)
        returnButton.position = CGPoint(x: ScreenSize.width * -0.43, y: ScreenSize.heigth * 0.45)

        // Settings
        musicOnOffButton.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * 0.15)
        musicSlider.frame.origin = CGPoint(x: (ScreenSize.width/2)-100,
                                           y: (ScreenSize.heigth/2)-15-50)
        effectOnOffButton.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * -0.15)
        effectSlider.frame.origin = CGPoint(x: (ScreenSize.width/2)-100,
                                            y: (ScreenSize.heigth/2)-15+50)

        
    }
    
    func addNodes() {
        addChild(background)
        addChild(title)
        addChild(returnButton)
        addChild(musicOnOffButton)
        addChild(effectOnOffButton)
    }
    
    func setupUIControl()  {
        self.musicSlider.moveIn()
        self.effectSlider.moveIn()
    }

    func addUIControl(to view: SKView) {
        view.addSubview(self.musicSlider)
        view.addSubview(self.effectSlider)
    }
    
    func addTarget() {
        musicSlider.addTarget(self, action: #selector(musicSliderValueDidChange(_:)), for: .valueChanged)
        effectSlider.addTarget(self, action: #selector(effectSliderValueDidChange(_:)), for: .valueChanged)
    }
    
    func setupValori() {
        musicSlider.value = gameinfo.getSoundVolume(forKey: kMusicVolume)
        effectSlider.value = gameinfo.getSoundVolume(forKey: kEffectVolume)
    }

    func returnToMainMenu() {
        gameinfo.saveAccount()
        JDSManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.moveIn(with: .right, duration: 0.5))
    }
    
    func setMusicOnOff() {
        let musicState = gameinfo.getSound(forKey: kMusicState)
        (musicState) ? NotificationCenter.default.post(name: stopBackgroundMusicNotificationName, object: nil, userInfo: nil) : NotificationCenter.default.post(name: startBackgroundMusicNotificationName, object: nil, userInfo: nil)
        gameinfo.setSounds(!musicState, forKey: kMusicState)
    }

    func setEffectOnOff() {
        let effectState = gameinfo.getSound(forKey: kEffectState)
        (effectState) ? NotificationCenter.default.post(name: stopSoundEffectNotificationName, object: nil, userInfo: nil) : NotificationCenter.default.post(name: startSoundEffectNotificationName, object: nil, userInfo: nil)
        gameinfo.setSounds(!effectState, forKey: kEffectState)
    }
    
    func musicSliderValueDidChange(_ sender:UISlider!){
        gameinfo.setSoundVolume(sender.value, forKey: kMusicVolume)
        NotificationCenter.default.post(name: changeVolumeBackgroundMusicNotificationName, object: nil, userInfo: nil)
        //print("MusicSlider step value \(Int(JDSManager.shared.mainAudio.getVolume()))")
    }

    func effectSliderValueDidChange(_ sender:UISlider!){
        gameinfo.setSoundVolume(sender.value, forKey: kEffectVolume)
        NotificationCenter.default.post(name: changeVolumeSoundEffectNotificationName, object: nil, userInfo: nil)
        //print("EffectSlider step value \(Int(JDSManager.shared.effectAudio.getVolume()))")
    }

}
