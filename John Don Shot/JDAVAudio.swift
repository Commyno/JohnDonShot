//
//  JDAVAudio.swift
//  John Don Shot
//
//  Created by Giovanni on 22/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

// Public
let kBackgroundMusicName = "BackgroundMusic"
let mp3MusicExtension = "mp3"
let wavSoundExtension = "wav"

// Music Notification
let startBackgroundMusicNotificationName = Notification.Name("startBackgroundMusicNotificationName")
let stopBackgroundMusicNotificationName = Notification.Name("stopBackgroundMusicNotificationName")
let changeVolumeBackgroundMusicNotificationName = Notification.Name("changeVolumeBackgroundMusicNotificationName")

// Music Notification
let startSoundEffectNotificationName = Notification.Name("startSoundEffectNotificationName")
let stopSoundEffectNotificationName = Notification.Name("stopSoundEffectNotificationName")
let changeVolumeSoundEffectNotificationName = Notification.Name("changeVolumeSoundEffectNotificationName")

struct FileToPlay {
    var filename: String
    var estensione: String
    var numberOfLoops: Int
    
    init(filename: String, estensione: String, numberOfLoops: Int) {
        self.filename = filename
        self.estensione = estensione
        self.numberOfLoops = numberOfLoops
    }
}

class JDAVAudio {
    
    // Private var audio
    private var player: AVAudioPlayer? = nil
    
    init(volume: Float = 1.0){
        
        guard let asset = NSDataAsset(name:kBackgroundMusicName) else {
            print("error initializing AVAudioPlayer")
            return
        }
        do {
            
            let p = try AVAudioPlayer(data: asset.data, fileTypeHint: mp3MusicExtension)

            p.numberOfLoops = -1
            p.setVolume(volume, fadeDuration: 0.1)
            p.prepareToPlay()
            
            player = p

        } catch {
            print("error initializing AVAudioPlayer")
            return
        }

    }
    
    // Function
    
    func load(fileToPlay: String, estensione: String, volume: Float? = nil) -> Bool{
        
        if (fileToPlay == ""){
            print("error loading Sound into AVAudioPlayer")
            return false
        }
        
        guard let asset = NSDataAsset(name:fileToPlay) else {
            print("error initializing AVAudioPlayer")
            return false
        }
        
        if (player != nil) {
            player?.stop()
        }

        if let volume = volume {
            player?.volume = volume
        }

        do {
            let vol = player?.volume
            player = try AVAudioPlayer(data: asset.data, fileTypeHint: mp3MusicExtension)
            player?.volume = vol!
            play()
        } catch {
            return false
        }
        
        return true
    }

    /* "numberOfLoops" is the number of times that the sound will return to the beginning upon reaching the end.
     A value of zero means to play the sound just once.
     A value of one will result in playing the sound twice, and so on..
     Any negative number will loop indefinitely until stopped.
     */
    func play(numberOfLoops: Int = 0){
        player?.numberOfLoops = numberOfLoops
        player?.currentTime = 0
        player?.play()
        let volume = player?.volume
    }
    
    func stop(){
        player?.stop()
    }


    // Property
    
    public func setVolume(volume: Float = 1.0) {
        player?.setVolume(volume, fadeDuration: 0.1)
    }

    public func getVolume() -> Float {
        return (player?.volume)!
    }

}
