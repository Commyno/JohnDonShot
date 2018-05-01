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
    
    // Info di gioco salvate
    private var level:Int
    private var experience:CGFloat
    private var highscore:Int
    
    // Settaggi di gioco salgate
    private var musicOn:Bool
    private var effectOn:Bool
    private var volumeMusic:Float
    private var volumeEffect:Float
    
    // Info di gioco aleatorie
    private var gold:Int
    
    
    // ----------------------------------------------------------------

    private struct Data{
        private let documentDir:NSString
        let fullPath:String
        let plist:NSMutableDictionary
        
        init(){
            documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            fullPath = documentDir.appendingPathComponent("userinfo.plist")
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

        level = 0
        gold = 0
        experience = 0.0
        highscore = 0
        
        musicOn = true
        effectOn = true
        volumeMusic = 10.0
        volumeEffect = 10.0
        
        //UserDefaults.standard.set(value, forKey: kScore)
        //UserDefaults.standard.set(value, forKey: kBestScore)


        // ----------------------------------------------------------------

        data = Data()
    
    }

    // Caricamento dei valori da file
    func load() -> ErrorReturnCode{
        
        // ----------------------------------------------------------------
        // Caricamento di tutti gli oggetti che si sono instanziati
        // ----------------------------------------------------------------

        level = data.plist.value(forKey: "Level") as! Int
        gold = data.plist.value(forKey: "Coin") as! Int
        experience = data.plist.value(forKey: "Experience") as! CGFloat
        highscore = data.plist.value(forKey: "Highscore") as! Int
        
        musicOn = data.plist.value(forKey: "MusicOn") as! Bool
        effectOn = data.plist.value(forKey: "EffectOn") as! Bool
        volumeMusic = data.plist.value(forKey: "VolumeMusic") as! Float
        volumeEffect = data.plist.value(forKey: "VolumeEffect") as! Float

        // ----------------------------------------------------------------

        return (true, "No error")
    }
    
    func save(){
        if !data.plist.write(toFile: data.fullPath, atomically: false){
            print("Saving Error - AccountInfo.selectToonIndex")
        }
    }

    // ----------------------------------------------------------------
    // Dichiarazione delle proprietà relative agli oggetti instanziati
    // per permettere il recupero del valore esternamente
    // ----------------------------------------------------------------

    // UI Object
    
    internal func getGoldBalance() -> Int{
        return self.gold
    }
    
    func setScore(_ value: Int) {
        
        if value > getBestScore() {
            setBestScore(value)
        }
        
        UserDefaults.standard.set(value, forKey: kScore)
        UserDefaults.standard.synchronize()
    }

    func getScore() -> Int {
        return UserDefaults.standard.integer(forKey: kScore)
    }
    
    func getBestScore() -> Int {
        return UserDefaults.standard.integer(forKey: kBestScore)
    }
    
    func setBestScore(_ value: Int) {
        
        UserDefaults.standard.set(value, forKey: kBestScore)
        UserDefaults.standard.synchronize()
    }

    // ----------------------------------------------------------------

}
