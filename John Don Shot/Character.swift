//
//  Character.swift
//  John Don Shot
//
//  Created by Giovanni on 06/05/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import Foundation
import SpriteKit

class Character{

    enum CharacterType:String{
        case Alpha = "ALPHA"
        case Beta = "BETA"
        
        var string:String{
            let name = String(describing: self)
            return name
        }
    }

    deinit {
        print ("Toon class has been deinitiated.")
    }

    private var size:CGSize
    private var node:SKSpriteNode
    private var title:String = ""
    private var experience:Int = 0
    private var level:Int = 1
    //private var bullet:Projectile?

    // Initialize
    private var charType:CharacterType

    init(char:CharacterType, scene: SKScene){

        var mainTexture:SKTexture!

        switch char {
        case .Alpha:
            mainTexture = global.getMainTextures(textures: .Character_Alpha)
        case .Beta:
            mainTexture = global.getMainTextures(textures: .Character_Beta)
        default:
            // default - Warning
            mainTexture = global.getMainTextures(textures: .Character_Alpha)
        }
        
        self.charType = char
        self.size = mainTexture.size()

        node = SKSpriteNode(texture: mainTexture)
        node.name = "player"
        node.position = CGPoint(x: ScreenSize.width/2, y: 100)
        node.size = self.size
        node.run(SKAction.scale(to: 0.5, duration: 0.0))

        scene.addChild(node)
    }

    internal func load(infoDict:NSDictionary){

        self.level = infoDict.value(forKey: "Level") as! Int
        self.experience = infoDict.value(forKey: "Experience") as! Int
        self.title = infoDict.value(forKey: "Title") as! String

        let bulletLevel = infoDict.value(forKey: "BulletLevel") as! Int
        //bullet = Projectile(posX: node.position.x, posY: node.position.y, char: self.charType, bulletLevel: bulletLevel)

        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width/4, height: node.size.height/2))
        node.physicsBody!.isDynamic = true // allow physic simulation to move it
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.allowsRotation = false // not allow it to rotate
        node.physicsBody!.collisionBitMask = 0
        node.physicsBody!.categoryBitMask = PhysicsCategory.Player
        node.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy

    }
    
    internal func getNode() -> SKSpriteNode{
        return node
    }
    
    

}
