//
//  AccountInfo.swift
//  John Don Shot
//
//  Created by Giovanni on 20/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import Foundation
import SpriteKit

class AccountInfo{
    
    // ----------------------------------------------------------------
    // Inserire di seguito le info relative al gioco che si sta creando
    // che saranno poi salvate e conservate
    // ----------------------------------------------------------------
    
    private let kMusicOn = "MusicOn"
    private let kEffectOn = "EffectOn"
    private let kVolumeMusic = "VolumeMusic"
    private let kVolumeEffect = "VolumeEffect"
    
    private let kLevel = "Level"
    private let kExperience = "Experience"
    private let kHighscore = "Highscore"
    private let kCurrentCharacter = "CurrentCharacter"
    private let kCharacters = "Characters"


    // Settaggi di gioco salgate
    private var musicOn:Bool
    private var effectOn:Bool
    private var volumeMusic:Float
    private var volumeEffect:Float

    // Info di gioco salvate
    private var level:Int
    private var experience:Int
    private var highscore:Int
    private var currentCharacterIndex:Int
    //private var characters:[Character]

    struct character: Codable {
        var Title: String
        var Experience: Int
        var Level: Int
        var BulletLevel: Int
    }
    struct characters: Codable {
        var Alpha: character
        var Beta: character
    }
    private var chars:characters

    // Info di gioco aleatorie
    // private var gold:Int
    
    
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
            //let url = Bundle.main.url(forResource: "userinfo", withExtension: "plist")
            //guard let plist = NSDictionary(contentsOf: url!) as? NSMutableDictionary else {
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
        experience = 0
        highscore = 0
        currentCharacterIndex = 0
        chars = characters(Alpha:character(Title: "Titolo",
                                           Experience: 0,
                                           Level: 0,
                                           BulletLevel: 0),
                           Beta:character(Title: "Titolo",
                                          Experience: 0,
                                          Level: 0,
                                          BulletLevel: 0))
        
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

        // Caricamento dei personaggi usati
        level = data.plist.value(forKey: kLevel) as! Int
        experience = data.plist.value(forKey: kExperience) as! Int
        highscore = data.plist.value(forKey: kHighscore) as! Int
        currentCharacterIndex = data.plist.value(forKey: kCurrentCharacter) as! Int
        //chars = data.plist.value(forKey: "Characters") as! characters

        // ----------------------------------------------------------------

        return ErrorReturnCodeOk
    }

    func save() -> ErrorReturnCode {
        
        data.plist.setValue(musicOn, forKey: kMusicOn)
        data.plist.setValue(effectOn, forKey: kEffectOn)
        data.plist.setValue(volumeMusic, forKey: kVolumeMusic)
        data.plist.setValue(volumeEffect, forKey: kVolumeEffect)
        
        data.plist.setValue(level, forKey: kLevel)
        data.plist.setValue(experience, forKey: kExperience)
        data.plist.setValue(highscore, forKey: kHighscore)
        data.plist.setValue(currentCharacterIndex, forKey: kCurrentCharacter)

        //data.plist.setValue(chars, forKey: kCharacters)
        
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

        level = 0
        experience = 0
        highscore = 0
        currentCharacterIndex = 0

        return save()
    }

    // ----------------------------------------------------------------
    // Dichiarazione delle proprietà relative agli oggetti instanziati
    // per permettere il recupero del valore esternamente
    // ----------------------------------------------------------------

    // Settings Object
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

    // Character Object
    func getCurrentCharacter() -> character{
        return chars.Alpha
    }
    func getCurrentCharacterIndex() -> Int{
        return currentCharacterIndex
    }
    func selectCharacterIndex(index: Int){
        currentCharacterIndex = index
        data.plist.setValue(index, forKey: "CurrentCharacter")
        if !data.plist.write(toFile: data.fullPath, atomically: false){
            print("Saving Error - AccountInfo.selectToonIndex")
        }
    }
    
    // ----------------------------------------------------------------

}
