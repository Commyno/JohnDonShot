//
//  HUDBar.swift
//  John Don Shot
//
//  Created by Giovanni on 20/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import SpriteKit

class HUDBar:SKSpriteNode{

    private var mainRootWidth:CGFloat = 0
    private var mainRootHeight:CGFloat = 0
    private var firstTemplate:SKSpriteNode!

    convenience init(screenSize: CGSize){
        self.init()
        
        name = "HUDBar"
        color = .clear
        
        //mainRootWidth = screenSize.width
        //mainRootHeight = screenSize.height
        
        size = CGSize(width: screenSize.width, height: screenSize.height)
        anchorPoint = CGPoint(x: 0, y: 0)
        position = CGPoint(x: 0, y: 0)
        
        firstTemplate = generateTemplate(width: screenSize.width, height: screenSize.height, name: name!)
        
        addChild(firstTemplate)

    }
    
    private func generateTemplate(width:CGFloat, height:CGFloat, name:String) -> SKSpriteNode{
        
        let node = SKSpriteNode()
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.color = .clear
        node.name = name
        node.size = CGSize(width: width, height: height)
        node.position = CGPoint(x: 0, y: 0)
        
        // ----------------------------------------------------------------
        // Inserire la generazione del template dell'HUD
        // ----------------------------------------------------------------

        
        
        // ----------------------------------------------------------------

        return node

    }
    
    internal func updateHUD(){

        // ----------------------------------------------------------------
        // Inserire gli aggiornamenti degli oggetti esposti nell'HUB
        // ----------------------------------------------------------------
        
        
        
        // ----------------------------------------------------------------

    }
    
}
