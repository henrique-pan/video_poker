//
//  Hand.swift
//  video_poker
//
//  Created by eleves on 2017-10-11.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation

// Entity that represents a hand
class Hand {
    
    var handName: String!
    
    var multiplier: Int!
    
    // Constructor to a new hand
    init(handName: String!, multiplier: Int!) {
        self.handName = handName
        self.multiplier = multiplier
    }
    
}
