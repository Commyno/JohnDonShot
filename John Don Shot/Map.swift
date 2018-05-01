//
//  Map.swift
//  John Don Shot
//
//  Created by Giovanni on 20/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import Foundation
import SpriteKit

class Map: NSObject{

    private var timer:Timer?
    
    private var maptextures:[SKTexture]
    //private var bottomTexture:SKTexture
    private var midTexture:SKTexture
    //private var topTexture:SKTexture
    private var currIndex:Int

    //let top:SKSpriteNode
    let mid:SKSpriteNode
    //let bottom:SKSpriteNode
    
    init(maps:[SKTexture], scene:SKScene){
        
        if maps.count < 1{
            fatalError("maps should have at least 1 textures.")
        }

        currIndex = randomInt(min: 0, max: maps.count - 1)
        maptextures = maps
        midTexture = maptextures[currIndex]
    
        let tsize = CGSize(width: ScreenSize.width, height: ScreenSize.width)

        // Background
        mid = SKSpriteNode()
        mid.texture = midTexture
        mid.size = tsize
        mid.anchorPoint = CGPoint(x: 0.5, y: 0)
        mid.position = CGPoint(x: ScreenSize.width/2, y: mid.size.height/2)
        mid.zPosition = -5

        scene.addChild(mid)
        //scene.addChild(bottom)
        //scene.addChild(top)

    }
    
    private func getNextTexture() -> SKTexture{
        if currIndex + 1 >= maptextures.count {
            currIndex = 0
            return maptextures[0]
        }
        else{
            currIndex = currIndex + 1
            return maptextures[currIndex]
        }
        
    }
    
    func run(){
        
        // Timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }
    
    @objc func update(){

    }

}
