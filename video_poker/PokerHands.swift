//
//  PokerHands.swift
//  video_poker
//
//  Created by eleves on 2017-10-11.
//  Copyright © 2017 com.henrique. All rights reserved.
//

class PokerHands {
    
    func royalFlush(hand: [Card]) -> Bool {
        //--
        var cards = [Int]()
        var suits = [String]()
        //--
        for c in hand {
            cards.append(c.value)
            suits.append(c.suit)
        }
        //--
        cards.sort{$0 < $1}
        suits.sort{$0 < $1}
        //--
        if cards != [1, 10, 11, 12, 13] {
            return false
        }
        //--
        if !flush(hand: hand) {
            return false
        }
        //--
        return true
    }
    
    func straightFlush(hand: [Card]) -> Bool {
        //--
        var cards = [Int]()
        var suits = [String]()
        //--
        for c in hand {
            cards.append(c.value)
            suits.append(c.suit)
        }
        //--
        cards.sort{$0 < $1}
        suits.sort{$0 < $1}
        //--
        if !straight(hand: hand) {
            return false
        }
        //--
        if !flush(hand: hand) {
            return false
        }
        //--
        return true
    }
    
    func fourKind(hand: [Card]) -> Bool {
        //--
        let cards = parseTupleReturnArray(hand: hand)
        //--
        if !threeOrFourKind(cards: cards, threeOrFour: 4) {
            return false
        }
        //--
        return true
    }

    func fullHouse(hand: [Card]) -> Bool {
        //--
        let cards = parseTupleReturnArray(hand: hand)
        //--
        var repeats: [Int: Int] = [:]
        //--
        for card in cards {
            repeats[card.value] = (repeats[card.value] ?? 0) + 1
        }
        //--
        if repeats.count != 2 {
            return false
        }
        //--
        return true
    }

    func flush(hand: [Card]) -> Bool {
        //--
        var suits = [String]()
        //--
        for c in hand {
            suits.append(c.suit)
        }
        //--
        let suit = suits[0]
        //--
        for aSuit in suits {
            if aSuit != suit {
                return false
            }
        }
        //--
        return true
    }

    func straight(hand: [Card]) -> Bool {
        //--
        var cards = [Int]()
        //--
        for c in hand {
            cards.append(c.value)
        }
        //--
        cards.sort{$0 < $1}
        //--
        if cards == [1, 10, 11, 12, 13] {
            return true
        }
        //--
        var number = cards[0]
        //--
        for i in 0..<cards.count {
            if number != cards[i] {
                return false
            } else {
                number = number + 1
            }
        }
        //--
        return true
    }

    func threeKind(hand: [Card]) -> Bool {
        //--
        let cards = parseTupleReturnArray(hand: hand)
        //--
        if !threeOrFourKind(cards: cards, threeOrFour: 3) {
            return false
        }
        //--
        return true
    }

    func twoPairs(hand: [Card]) -> Bool {
        //--
        let cards = parseTupleReturnArray(hand: hand)
        //--
        var repeats: [Int: Int] = [:]
        //--
        for card in cards {
            repeats[card.value] = (repeats[card.value] ?? 0) + 1
        }
        //--
        if repeats.count != 3 {
            return false
        }
        //--
        for (_, val) in repeats {
            if val == 2 {
                return true
            }
        }
        //--
        return false
    }
    
    func onePair(hand: [Card]) -> Bool {
        //--
        let cards = parseTupleReturnArray(hand: hand)
        //--
        var repeats: [Int: Int] = [:]
        //--
        for card in cards {
            repeats[card.value] = (repeats[card.value] ?? 0) + 1
        }
        //--
        for (key, val) in repeats {
            if val == 2, key == 1 || key >= 11 {
                return true
            }
        }
        //--
        return false
    }
    
    private func parseTupleReturnArray(hand: [Card]) -> [Card] {
        //--
        var cards = [Card]()
        //--
        for c in hand {
            cards.append(c)
        }
        //--
        return cards.sorted{$0.value < $1.value}
    }
    
    private func threeOrFourKind(cards: [Card], threeOrFour: Int) -> Bool {
        //--
        var repeats: [Int: Int] = [:]
        //--
        for card in cards {
            repeats[card.value] = (repeats[card.value] ?? 0) + 1
        }
        //--
        for (_, val) in repeats {
            if val == threeOrFour {
                return true
            }
        }
        //--
        return false
    }
    
}
