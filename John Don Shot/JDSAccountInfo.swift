//
//  JDSAccountInfo.swift
//  John Don Shot
//
//  Created by Giovanni on 20/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import Foundation
import SpriteKit

class JDSAccountInfo{
    
    // ----------------------------------------------------------------
    // Inserire di seguito le info relative al gioco che si sta creando
    // che saranno poi salvate e conservate
    // ----------------------------------------------------------------
    
    private let kMusicOn = "MusicOn"
    private let kEffectOn = "EffectOn"
    private let kVolumeMusic = "VolumeMusic"
    private let kVolumeEffect = "VolumeEffect"

    // Settaggi di gioco salgate
    private var musicOn:Bool
    private var effectOn:Bool
    private var volumeMusic:Float
    private var volumeEffect:Float

    // Info di gioco salvate
    private var level:Int
    private var experience:CGFloat
    private var highscore:Int
    
    // Info di gioco aleatorie
    private var gold:Int
    
    
    // ----------------------------------------------------------------

    private struct Data{
        let documentDir: NSString
        let fileName: String
        let fullPath:String
        let plist:NSMutableDictionary
        
        init(){
            documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            fileName = "userinfo.plist"
            fullPath = documentDir.appendingPathComponent(fileName)
            guard let plist = NSMutableDictionary(contentsOfFile: fullPath) else {
                fatalError("plist is nil - Check JDSAccountInfo.swift")
            }
            self.plist = plist
        }
    }

    private let data:Data
    
    init(){

        // ----------------------------------------------------------------
        // Inizializzazione di tutti gli oggetti che si sono instanziati
        // ----------------------------------------------------------------

        musicOn = true
        effectOn = true
        volumeMusic = 1.0
        volumeEffect = 1.0

        level = 0
        gold = 0
        experience = 0.0
        highscore = 0

        // ----------------------------------------------------------------

        data = Data()
    
    }

    // Caricamento dei valori da file
    func load() -> ErrorReturnCode{
        
        // ----------------------------------------------------------------
        // Caricamento di tutti gli oggetti che si sono instanziati
        // ----------------------------------------------------------------

        musicOn = data.plist.value(forKey: kMusicOn) as! Bool
        effectOn = data.plist.value(forKey: kEffectOn) as! Bool
        volumeMusic = data.plist.value(forKey: kVolumeMusic) as! Float
        volumeEffect = data.plist.value(forKey: kVolumeEffect) as! Float

        // ----------------------------------------------------------------

        return ErrorReturnCodeOk
    }
    /*
    func prepareToSave() {
        musicOn = UserDefaults.standard.bool(forKey: kMusicState)
        effectOn = UserDefaults.standard.bool(forKey: kEffectState)
        volumeMusic = UserDefaults.standard.float(forKey: kMusicVolume)
        volumeEffect = UserDefaults.standard.float(forKey: kEffectVolume)
    }
 */
    
    func save() -> ErrorReturnCode {
        
        data.plist.setValue(musicOn, forKey: kMusicOn)
        data.plist.setValue(effectOn, forKey: kEffectOn)
        data.plist.setValue(volumeMusic, forKey: kVolumeMusic)
        data.plist.setValue(volumeEffect, forKey: kVolumeEffect)

        if !data.plist.write(toFile: data.fullPath, atomically: false){
            return (false, "Saving Error - AccountInfo.selectToonIndex")
        }
        return ErrorReturnCodeOk

    }
    
    func hardReset()  -> ErrorReturnCode {
        
        musicOn = true
        effectOn = true
        volumeMusic = 1.0
        volumeEffect = 1.0

        return save()
    }

    // ----------------------------------------------------------------
    // Dichiarazione delle proprietà relative agli oggetti instanziati
    // per permettere il recupero del valore esternamente
    // ----------------------------------------------------------------

    // UI Object
    func setMusicOn(_ stato: Bool){
        musicOn = stato
    }
    func getMusicOn() -> Bool{
        return musicOn
    }

    func setEffectOn(_ stato: Bool){
        effectOn = stato
    }
    func getEffectOn() -> Bool{
        return effectOn
    }

    func setVolumeMusic(_ volume: Float){
        volumeMusic = volume
    }
    func getVolumeMusic() -> Float{
        return volumeMusic
    }
    
    func setVolumeEffect(_ volume: Float){
        volumeEffect = volume
    }
    func getVolumeEffect() -> Float{
        return volumeEffect
    }

    // ----------------------------------------------------------------

}
