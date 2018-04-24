//
//  JDSManager.swift
//  John Don Shot
//
//  Created by Giovanni on 13/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import Foundation
import SpriteKit

//let AppId = "123456"
//let chartboostAppID = "5a3cfaf8e6d7050d5c5c6dce"
//let chartboostAppSignature = "97a43ed515d78826130881e8c0eed747185d0d74"

class JDSManager {
    
    enum SceneType {
        case MainMenu, Gameplay, GameOver, SettingsMenu
    }
    
    private init() {}
    static let shared = JDSManager()
    
    public func launch() {
        firstLaunch()
    }
    
    private func firstLaunch() {
        if !UserDefaults.standard.bool(forKey: "isFirstLaunch") {
            
            print("This is our first launch")
            JDSPlayerStats.shared.setSounds(true)
            JDSPlayerStats.shared.saveMusicVolume(0.7)
            JDSPlayerStats.shared.setEffects(true)
            JDSPlayerStats.shared.saveEffectVolume(0.7)
            
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            UserDefaults.standard.synchronize()
        }
    }
    
    func transition(_ fromScene: SKScene, toScene: SceneType, transition: SKTransition? = nil ) {
        guard let scene = getScene(toScene) else { return }
        
        if let transition = transition {
            scene.scaleMode = .resizeFill
            fromScene.view?.presentScene(scene, transition: transition)
        } else {
            scene.scaleMode = .resizeFill
            fromScene.view?.presentScene(scene)
        }
        
    }
    
    func getScene(_ sceneType: SceneType) -> SKScene? {
        switch sceneType {
        case SceneType.MainMenu:
            return MainMenu(size: CGSize(width: ScreenSize.width, height: ScreenSize.heigth))
        case SceneType.Gameplay:
            return Gameplay(size: CGSize(width: ScreenSize.width, height: ScreenSize.heigth))
        case SceneType.SettingsMenu:
            return SettingsMenu(size: CGSize(width: ScreenSize.width, height: ScreenSize.heigth))
        case SceneType.GameOver:
            return GameOver(size: CGSize(width: ScreenSize.width, height: ScreenSize.heigth))
        }
    }
    
    func runEffect(_ fileName: String) {
        if JDSPlayerStats.shared.getSound() {
            
            let fileToPlay: [String: String] = ["fileToPlay": fileName ]
            //NotificationCenter.default.post(name:startEffectSoundNotificationName, object: self, userInfo:fileToPlay)
        }
    }
    
    func showAlert(on scene: SKScene, title: String, message: String, preferredStyle: UIAlertControllerStyle = .alert, actions: [UIAlertAction], animated: Bool = true, delay: Double = 0.0, completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for action in actions {
            alert.addAction(action)
        }
        
        let wait = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: wait) {
            scene.view?.window?.rootViewController?.present(alert, animated: animated, completion: completion)
        }
        
    }
    
    func share(on scene: SKScene, text: String, image: UIImage?, exculdeActivityTypes: [UIActivityType] ) {
        // text to share
        //let text = "This is some text that I want to share."
        guard let image = image else {return}
        // set up activity view controller
        let shareItems = [ text, image ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = scene.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = exculdeActivityTypes
        
        // present the view controller
        scene.view?.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
}
