//
//  GameInfo.swift
//  John Don Shot
//
//  Created by Giovanni on 20/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import Foundation
import SpriteKit

let kScore = "kScore"
let kBestScore = "kBestScore"

protocol GameInfoDelegate{
    
    func changeGameState(_ state: GameState)
    
}

class GameInfo: GameInfoDelegate{

    static let shared = GameInfo()

    // Main Variables
    weak fileprivate var mainScene:SKScene?
    fileprivate var account:JDSAccountInfo
    fileprivate var timer:Timer?

    // Secondary Variables
    fileprivate var gamestate:GameState
    
    // Public Variables
    var map:Map?

    //
    // Init
    //
    
    init(){

        account = JDSAccountInfo()
        gamestate = .NoState

    }
    
    func load(scene: SKScene) -> ErrorReturnCode {
        var loadStatus:ErrorReturnCode = ErrorReturnCodeOk

        mainScene = scene

        if (gamestate != .NoState) {
            return loadStatus
        }

        // load account
        loadStatus = loadAccount()
        if (!loadStatus.0) {
            return loadStatus
        }

        // load background music and effect
        loadStatus = JDSManager.shared.initAudio()
        if (!loadStatus.0) {
            return loadStatus
        }
        //JDSManager.shared.mainAudio.play()

        // Notification
        notification()
        
        gamestate = .WaitingState
        
        return ErrorReturnCodeOk

     }
    
    internal func prepareToChangeScene(){
        JDSManager.shared.mainAudio.stop()
        map?.prepareToChangeScene()
        timer?.invalidate()
    }

    internal func getGameState() -> GameState {
        return gamestate
    }

    internal func changeGameState(_ state: GameState){
        gamestate = state
        updateGameState()
    }

    private func notification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(startAudioMusic(_:)),
                                               name: startBackgroundMusicNotificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stopAudioMusic(_:)),
                                               name: stopBackgroundMusicNotificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeVolumeMusic(_:)),
                                               name: changeVolumeBackgroundMusicNotificationName,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(startAudioEffect(_:)),
                                               name: startSoundEffectNotificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stopAudioEffect(_:)),
                                               name: stopSoundEffectNotificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeVolumeEffect(_:)),
                                               name: changeVolumeSoundEffectNotificationName,
                                               object: nil)
    }
    
    private func updateGameState(){
        guard let mainscene = mainScene else{
            print ("ERROR D00: Check updateGameState() from GameInfo")
            return
        }

        switch gamestate {
        case .NoState:
            break
        case .Start:
            // Load Map
            map = Map(maps: global.getTextures(textures: .Map_Base), scene: mainscene)
            
            // Applica una sequeza di azioni
            self.map!.run()

            break
        case .WaitingState:
            break
        default:
            print("Current State: ", gamestate)
        }
    }

    
    //
    // Game play
    //
        
    func setScore(_ value: Int) {
        
        if value > getBestScore() {
            setBestScore(value)
        }
        
        UserDefaults.standard.set(value, forKey: kScore)
        //UserDefaults.standard.synchronize()
    }
    
    func getScore() -> Int {
        return UserDefaults.standard.integer(forKey: kScore)
    }
    
    func setBestScore(_ value: Int) {
        UserDefaults.standard.set(value, forKey: kBestScore)
        //UserDefaults.standard.synchronize()
    }
    
    func getBestScore() -> Int {
        return UserDefaults.standard.integer(forKey: kBestScore)
    }

    //
    // Audio Settings
    //
    
    func setSounds(_ state: Bool, forKey defaultName: String) {
        UserDefaults.standard.set(state, forKey: defaultName)
        //UserDefaults.standard.synchronize()
		if (defaultName == kMusicState) {
			(state) ? JDSManager.shared.mainAudio.play() : JDSManager.shared.mainAudio.stop()
		}
		if (defaultName == kEffectState) {
			(state) ? JDSManager.shared.effectAudio.play() : JDSManager.shared.effectAudio.stop()
		}
    }
    
    func getSound(forKey defaultName: String) -> Bool {
        return UserDefaults.standard.bool(forKey: defaultName)
    }
    
    func setSoundVolume(_ value: Float, forKey defaultName: String) {
        UserDefaults.standard.set(value, forKey: defaultName)
        //UserDefaults.standard.synchronize()
		if (defaultName == kMusicVolume) {
			JDSManager.shared.mainAudio.setVolume(volume: value)
		}
		if (defaultName == kEffectState) {
			JDSManager.shared.effectAudio.setVolume(volume: value)
		}
    }
    
    func getSoundVolume(forKey defaultName: String) -> Float {
        return UserDefaults.standard.float(forKey: defaultName)
	}
    
    func loadAccount() -> ErrorReturnCode{
        var loadStatus = ErrorReturnCodeOk
        
        loadStatus = account.load()
        if (!loadStatus.0) {
            return loadStatus
        }

        UserDefaults.standard.setValue(account.getMusicOn(), forKey: kMusicState)
        UserDefaults.standard.setValue(account.getEffectOn(), forKey: kEffectState)
        UserDefaults.standard.setValue(account.getVolumeMusic(), forKey: kMusicVolume)
        UserDefaults.standard.setValue(account.getVolumeEffect(), forKey: kEffectVolume)
        
        return loadStatus
    }

    func saveAccount() -> ErrorReturnCode{
        var loadStatus = ErrorReturnCodeOk

        account.setMusicOn(UserDefaults.standard.bool(forKey: kMusicState))
        account.setEffectOn(UserDefaults.standard.bool(forKey: kEffectState))
        account.setVolumeMusic(UserDefaults.standard.float(forKey: kMusicVolume))
        account.setVolumeEffect(UserDefaults.standard.float(forKey: kEffectVolume))

        loadStatus = account.save()
        if (!loadStatus.0) {
            return loadStatus
        }

        return loadStatus
    }

    //
    // Notification Selector
    //
    
    @objc func startAudioMusic(_ notification: Notification) {
        if (!getSound(forKey: kMusicState)) { return }
        if let fileToPlay = notification.userInfo?["FileToPlay"] as! FileToPlay? {
            
            if (JDSManager.shared.mainAudio.load(fileToPlay: fileToPlay.filename, estensione: fileToPlay.estensione)) {
                JDSManager.shared.mainAudio.play(numberOfLoops: fileToPlay.numberOfLoops)
            } else {
                print("error start sound AVAudioPlayer")
            }
        }else {
            JDSManager.shared.mainAudio.play(numberOfLoops: 0)
        }
    }
    
    @objc func stopAudioMusic(_ notification: Notification) {
        JDSManager.shared.mainAudio.stop()
    }
    
    @objc func changeVolumeMusic(_ notification: Notification) {
        if let volume = notification.userInfo?["Volume"] as! Float? {
            JDSManager.shared.mainAudio.setVolume(volume: volume)
        }else {
            JDSManager.shared.mainAudio.setVolume(volume: getSoundVolume(forKey: kMusicVolume))
        }
    }
    
    @objc func startAudioEffect(_ notification: Notification) {
        if (!getSound(forKey: kEffectState)) { return }
        if let fileToPlay = notification.userInfo?["FileToPlay"] as! FileToPlay? {
            
            if (JDSManager.shared.effectAudio.load(fileToPlay: fileToPlay.filename, estensione: fileToPlay.estensione)) {
                JDSManager.shared.effectAudio.play(numberOfLoops: fileToPlay.numberOfLoops)
            } else {
                print("error start sound AVAudioPlayer")
            }
        }else {
            JDSManager.shared.effectAudio.play(numberOfLoops: 0)
        }
    }
    
    @objc func stopAudioEffect(_ notification: Notification) {
        JDSManager.shared.effectAudio.stop()
    }
    
    @objc func changeVolumeEffect(_ notification: Notification) {
        if let volume = notification.userInfo?["Volume"] as! Float? {
            JDSManager.shared.effectAudio.setVolume(volume: volume)
        }else {
            JDSManager.shared.effectAudio.setVolume(volume: getSoundVolume(forKey: kEffectVolume))
        }
    }

}
