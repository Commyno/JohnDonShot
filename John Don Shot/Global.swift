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


class Global {
    
    deinit {
        print ("Global is deinitiated")
    }
    
    static let sharedInstance = Global()
    
    enum Animation{
        case Map_Base
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

    // Scene
    private var map = [MapType:[SKTexture]]()

    // Characters
    private var character_sprite:[(SKTexture, SKTexture)] = []

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

    }
    
    func prioirityLoad(){
        
        isSetUp = true // Make sure this function is called only once.

        self.mapPreload()
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
        case .Map_Base:
            return map[.Base]!
        }
    }
}

let global:Global = Global.sharedInstance // Using this Singleton to access all textures
