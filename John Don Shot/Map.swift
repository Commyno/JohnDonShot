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
    private var bottomTexture:SKTexture
    private var topTexture:SKTexture
    private var currIndex:Int
    private var maxTexture:Int
    
    private var topLabel: SKLabelNode
    private var bottomLabel: SKLabelNode

    let top:SKSpriteNode
    let bottom:SKSpriteNode
    
    init(maps:[SKTexture], scene:SKScene){
        
        if maps.count < 1{
            fatalError("maps should have at least 1 textures.")
        }

        maxTexture = maps.count
        currIndex = randomInt(min: 0, max: maxTexture - 1)
        maptextures = maps

        topLabel = SKLabelNode(text: "prova")
        bottomLabel = SKLabelNode(text: "prova")

        if maxTexture > 1{
            bottomTexture = maptextures[0]
            topTexture = maptextures[1]
        } else {
            bottomTexture = maptextures[0]
            topTexture = maptextures[0]
        }
        let tsize = CGSize(width: ScreenSize.width, height: ScreenSize.heigth)

        // Background
        bottom = SKSpriteNode()
        bottom.texture = bottomTexture
        bottom.size = tsize
        bottom.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        bottom.position = CGPoint(x: ScreenSize.width/2, y: 0) //bottom.size.height/2)
        bottom.zPosition = -5
        bottomLabel.position = bottom.position
        bottomLabel.zPosition = 0

        top = SKSpriteNode()
        top.texture = topTexture
        top.size = tsize
        top.anchorPoint = CGPoint(x: 0.5, y: 0)
        top.position = CGPoint(x: ScreenSize.width/2, y: bottom.position.y + bottom.size.height)
        top.zPosition = -5
        topLabel.position = top.position
        topLabel.zPosition = 0

        (top.alpha, bottom.alpha) = (0.0, 0.0)
        print(scene)
        scene.addChild(top)
        scene.addChild(bottom)
        scene.addChild(topLabel)
        scene.addChild(bottomLabel)

    }
    
    private func getNextTexture() -> SKTexture {
        currIndex = ( currIndex + 1 >= maxTexture ) ? 0 : currIndex + 1
        return maptextures[currIndex]
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
            bottom.texture = getNextTexture()
            bottom.position.y = top.position.y + top.size.height
            bottomLabel.text = "Numero: \(currIndex)"
        }
        else if top.position.y <= -top.size.height{
            top.texture = getNextTexture()
            top.position.y = bottom.position.y + bottom.size.height
            topLabel.text = "Numero: \(currIndex)"
        }
        bottomLabel.position = bottom.position
        topLabel.position = top.position

    }

    func prepareToChangeScene(){
        timer!.invalidate()
    }

}
