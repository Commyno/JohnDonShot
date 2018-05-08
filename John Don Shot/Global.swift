//
//  Global.swift
//  John Don Shot
//
//  Created by Giovanni on 20/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import ObjectiveC


struct PhysicsCategory {
    static let None      : UInt32 = 0
//    static let ImuneLegacy       : UInt32 = UInt32.max
    static let Player   :UInt32 = 1 << 1
    static let Enemy   : UInt32 = 1 << 2
    static let Projectile : UInt32 = 1 << 3
//    static let Currency : UInt32 = 1 << 4
//    static let Wall: UInt32 = 1 << 5
//    static let Imune       : UInt32 = 1 << 7
}

class Global {
    
    deinit {
        print ("Global is deinitiated")
    }
    
    static let sharedInstance = Global()
    
    enum Animation{
        // Mappe
        case Map_Base

        // Character
        case Character_Alpha
        case Character_Beta
    }
    
    // Music
    enum MusicBackgroungType:String{
        case BackgroundMusic = "BackgroundMusic"
    }

    // Effect
    enum EffectSoundType:String{
        case Tap = "TapSound"
    }
    
    // Mappa
    private enum MapType{
        case Base
    }
    private enum CharacterType{
        case Still
        case TurnLeft
        case TurnRight
        case Diing
    }

    // Scene
    private var map = [MapType:[SKTexture]]()
    private var character = [CharacterType:[SKTexture]]()

    // Characters
    private var characterSprite:[(SKTexture, SKTexture)] = []

    // ETC
    private var isSetUp:Bool = false
    private var totalFilesToLoad:Int = 1
    private var currentFilesLoaded:Int = 0
    private var serialQueue:DispatchQueue
    
    //
    // Init
    //

    private init (){

        serialQueue = DispatchQueue(label: "SerialLoadQueue")

        self.map[.Base] = []
        self.character[.Still] = []

    }
    
    func prioirityLoad(){
        
        isSetUp = true // Make sure this function is called only once.

        self.mapPreload()
        self.playerPreload()
        self.mainMenuPreload()
        self.settingsMenuPreload()
    
    }
    
    //
    // Preload Function
    //
    
    private func mapPreload(){
        let atlas = SKTextureAtlas(named: "Map")
        atlas.preload {
            for texture in atlas.textureNames{
                if texture.contains("map1_"){
                    self.map[.Base]!.append(atlas.textureNamed("map1_\(self.map[.Base]!.count + 1)"))
                    print(texture)
                }
            }
            self.checkmark()
        }
    }
    
    private func playerPreload(){
        let atlas = SKTextureAtlas(named: "Sheep")
        atlas.preload {
            for texture in atlas.textureNames{
                if texture.contains("sheep1_"){
                    self.character[.Still]!.append(atlas.textureNamed("sheep1_\(self.character[.Still]!.count + 1)"))
                    print(texture)
                }
            }
            self.checkmark()
        }
    }
    
    private func mainMenuPreload() {
        let atlas = SKTextureAtlas(named: "mainmenu")
        atlas.preload {
            self.checkmark()
        }
    }

    private func settingsMenuPreload() {
        let atlas = SKTextureAtlas(named: "settingsmenu")
        atlas.preload {
            self.checkmark()
        }
    }

    private func checkmark(){
        
        self.serialQueue.async {
            
            // Checkmark
            self.currentFilesLoaded += 1 // Increase Loaded File
            print("loaded: ", self.currentFilesLoaded)
            let left:Int = Int((CGFloat(self.currentFilesLoaded)/CGFloat(self.totalFilesToLoad)) * 100.0)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("ProgressNotificationName"), object: nil, userInfo: ["Left":left])
            }
            
            // Send Notification if all loaded
            if self.currentFilesLoaded == self.totalFilesToLoad {
                let nfname = Notification.Name("PreloadNotificationName")
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: nfname, object: nil, userInfo: nil)
                }
            }
        }
    }

    internal func getTextures(textures:Animation) -> [SKTexture]{
        switch textures{
        // Mappe
        case .Map_Base:
            return map[.Base]!
            
        // Sheep
        case .Character_Alpha:
            return character[.Still]!
        case .Character_Beta:
            return character[.Still]!
        }
    }

    internal func getMainTextures(textures:Animation) -> SKTexture{
        switch textures{
        // Mappe
        case .Map_Base:
            return map[.Base]![0]

        // Character
        case .Character_Alpha:
            return character[.Still]![0]
        case .Character_Beta:
            return character[.Still]![0]
        }
    }

}

let global:Global = Global.sharedInstance // Using this Singleton to access all textures
