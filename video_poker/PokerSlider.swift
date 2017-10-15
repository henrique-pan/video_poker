//
//  PokerSlider.swift
//  video_poker
//
//  Created by Henrique Nascimento on 2017-10-15.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class PokerSlider: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 10
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}
