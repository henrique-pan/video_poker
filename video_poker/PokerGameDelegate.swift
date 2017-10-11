//
//  PokerGameDelegate.swift
//  video_poker
//
//  Created by eleves on 2017-10-11.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation

protocol PokerGameDelegate {
    
    func doDeal()
    
    func displayRandomCards()
    
    func didSelectCard(slotIndex: Int!)
    
}
