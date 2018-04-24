//
//  JDSPlayerStats.swift
//  John Don Shot
//
//  Created by Giovanni on 13/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import Foundation
import SpriteKit

//let kBackgroundMusicExtension = "mp3"
//let kEffectSoundExtension = "wav"
let kSoundState = "kSoundState"
let kEffectState = "kEffectState"
let kNoAdsState = "kNoAdsState"
let kScore = "kScore"
let kBestScore = "kBestScore"
let kMusicVolume = "kMusicVolume"
let kEffectVolume = "kEffectVolume"

enum SoundFileName: String {
    case TapSound = "TapSound"
}

class JDSPlayerStats {
    
    private init() {}
    static let shared = JDSPlayerStats()
    
    // Play
    
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
    
    func setBestScore(_ value: Int) {
        UserDefaults.standard.set(value, forKey: kBestScore)
        UserDefaults.standard.synchronize()
    }
    
    func getBestScore() -> Int {
        return UserDefaults.standard.integer(forKey: kBestScore)
    }
    
    // Sound
    
    func setSounds(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: kSoundState)
        UserDefaults.standard.synchronize()
    }
    
    func getSound() -> Bool {
        return UserDefaults.standard.bool(forKey: kSoundState)
    }

    func setEffects(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: kEffectState)
        UserDefaults.standard.synchronize()
    }

    func getEffect() -> Bool {
        return UserDefaults.standard.bool(forKey: kEffectState)
    }

    func saveMusicVolume(_ value: Float) {
        UserDefaults.standard.set(value, forKey: kMusicVolume)
        UserDefaults.standard.synchronize()
    }
    
    func getMusicVolume() -> Float {
        return UserDefaults.standard.float(forKey: kMusicVolume)
    }
    
    func saveEffectVolume(_ value: Float) {
        UserDefaults.standard.set(value, forKey: kEffectVolume)
        UserDefaults.standard.synchronize()
    }
    
    func getEffectVolume() -> Float {
        return UserDefaults.standard.float(forKey: kEffectVolume)
    }

    
    // Ads
    
    func setNoAds(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: kNoAdsState)
        UserDefaults.standard.synchronize()
    }
    
    func getNoAds() -> Bool {
        return UserDefaults.standard.bool(forKey: kNoAdsState)
    }

    
}
