//
//  JDSlider.swift
//  John Don Shot
//
//  Created by Giovanni on 29/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import Foundation
import UIKit

class JDSlider: UISlider {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.minimumValue = 0.0
        self.maximumValue = 100.0
        self.value = 100.0
        self.isContinuous = true

    }

    /*
    override func didChangeValue(forKey key: String) {
        <#code#>
    }
    */
    
}
