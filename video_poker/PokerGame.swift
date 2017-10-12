//
//  PokerGame.swift
//  video_poker
//
//  Created by eleves on 2017-10-11.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation
import UIKit

class PokerGame {
    
    // MARK: Game Properties
    var cardSlots: [Slot]!
    var deckOfCards: [Card]! = []
    var hasStarted: Bool!
    var round = 0
    
    var totalBet = 0
    var totalCredit = 1000
    
    let pokerHands = PokerHands()
    
    func createDeckOfCards() {
        let suits = ["d", "h", "c", "s"]
        
        for suit in suits {
            for value in 1...13 {
                let newCard = Card(value: value, suit: suit)
                deckOfCards.append(newCard)
            }
        }
    }
    
    var totalCardsOnDeck: Int! {
        return deckOfCards.count
    }
    
    func cardAt(index: Int!) -> Card? {
        if index < 0 || index > (deckOfCards.count - 1) {
            return nil
        }
        
        return deckOfCards[index]
    }
    
    func cardsInSlot() -> [Card]! {
        var cards: [Card]! = []
        
        for slot in cardSlots {
            if let card = slot.card {
                cards.append(card)
            }
        }
        
        return cards
    }
    
    func setBet(total: Int) {
        totalBet = total
    }
    
    func bet() {
        totalCredit -= totalBet
    }
    
    func verifyHands() -> Hand? {
        
        if let cards = cardsInSlot(), cards.count > 0 {
            
            //royalFlush
            var result = pokerHands.royalFlush(hand: cards)
            if result {
                return Hand(handName: "royalFlush", multiplier: 250)
            }
            
            //straightFlush
            result = pokerHands.straightFlush(hand: cards)
            if result {
                return Hand(handName: "straightFlush", multiplier: 9)
            }
            
            //fourKind
            result = pokerHands.fourKind(hand: cards)
            if result {
                return Hand(handName: "fourKind", multiplier: 8)
            }
            
            //fullHouse
            result = pokerHands.fullHouse(hand: cards)
            if result {
                return Hand(handName: "fullHouse", multiplier: 7)
            }
            
            //flush
            result = pokerHands.flush(hand: cards)
            if result {
                return Hand(handName: "flush", multiplier: 6)
            }
            
            //straight
            result = pokerHands.straight(hand: cards)
            if result {
                return Hand(handName: "straight", multiplier: 5)
            }
            
            //threeKind
            result = pokerHands.threeKind(hand: cards)
            if result {
                return Hand(handName: "threeKind", multiplier: 4)
            }
            
            //twoPairs
            result = pokerHands.twoPairs(hand: cards)
            if result {
                return Hand(handName: "twoPairs", multiplier: 3)
            }
            
            //onePair
            result = pokerHands.onePair(hand: cards)
            if result {
                return Hand(handName: "onePair", multiplier: 2)
            }
        }
        
        return nil
    }
    
    func resetGame() {
        deckOfCards.removeAll()
        createDeckOfCards()
        hasStarted = false
        for slot in cardSlots {
            slot.card = nil
            slot.isSelected = false
            //let cardsBack = UIImage(named: "cards_back")
            //slot.uiImageView.image = cardsBack
        }
    }
    
   
    
}
