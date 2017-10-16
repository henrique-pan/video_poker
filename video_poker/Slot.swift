//
//  Slot.swift
//  video_poker
//
//  Created by eleves on 2017-10-11.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation
import UIKit

// Entity that represents each slot
class Slot {
    
    var uiImageView: UIImageView!
    
    var backgroundView: UIView!
    
    var labelHold: UILabel!
    
    var card: Card?
    
    var isSelected: Bool!
    
    // Constructor to a new Slot
    init(uiImageView: UIImageView!, backgroundView: UIView!, labelHold: UILabel!) {
        self.uiImageView = uiImageView
        self.backgroundView = backgroundView
        self.labelHold = labelHold
        self.isSelected = false
    }
    
}
