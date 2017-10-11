//
//  Slot.swift
//  video_poker
//
//  Created by eleves on 2017-10-11.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation
import UIKit

class Slot {
    
    var uiImageView: UIImageView!
    
    var card: Card?
    
    var isSelected: Bool!
    
    
    init(uiImageView: UIImageView!) {
        self.uiImageView = uiImageView
        self.isSelected = false
    }
    
    
    
}
