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
    private var singleTexture:SKTexture
    private var currIndex:Int

    let top:SKSpriteNode
    let bottom:SKSpriteNode
    
    init(maps:[SKTexture], scene:SKScene){
        
        if maps.count < 1{
            fatalError("maps should have at least 1 textures.")
        }

        currIndex = randomInt(min: 0, max: maps.count - 1)
        maptextures = maps
        singleTexture = maptextures[currIndex]

        let tsize = CGSize(width: ScreenSize.width, height: ScreenSize.heigth)

        // Background
        bottom = SKSpriteNode()
        bottom.texture = singleTexture
        bottom.size = tsize
        bottom.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        bottom.position = CGPoint(x: ScreenSize.width/2, y: 0) //bottom.size.height/2)
        bottom.zPosition = -5

        top = SKSpriteNode()
        top.texture = singleTexture
        top.size = tsize
        top.anchorPoint = CGPoint(x: 0.5, y: 0)
        top.position = CGPoint(x: ScreenSize.width/2, y: bottom.position.y + bottom.size.height)
        top.zPosition = -5

        (top.alpha, bottom.alpha) = (0.0, 0.0)
        print(scene)
        scene.addChild(top)
        scene.addChild(bottom)

    }
    
    func run(){
        
        // Timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);

        // fade in
        let fin = SKAction.fadeAlpha(to: 1, duration: 0.5)
        top.run(fin)
        bottom.run(fin)
        
        // Action
        let moveDown = SKAction.moveBy(x: 0, y: -2, duration: 0.01)
        bottom.run(SKAction.repeatForever(moveDown))
        top.run(SKAction.repeatForever(moveDown))
    }
    
    @objc func update(){
        if (bottom.position.y <= -bottom.size.height){
            bottom.position.y = top.position.y + top.size.height
        }
        else if top.position.y <= -top.size.height{
            top.position.y = bottom.position.y + bottom.size.height
        }
    }

    func prepareToChangeScene(){
        timer!.invalidate()
    }

}
