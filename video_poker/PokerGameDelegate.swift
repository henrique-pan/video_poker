//
//  PokerGameDelegate.swift
//  video_poker
//
//  Created by eleves on 2017-10-11.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation

protocol PokerGameDelegate {
    
    func didPlay()
    
    func doAnimation()
    
    func displayRandomCards()
    
    func didSelectCard(slot: Slot!)
    
    func didResetCard(slot: Slot!, isSelected: Bool!)
    
}
