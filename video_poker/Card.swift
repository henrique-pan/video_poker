//
//  Card.swift
//  video_poker
//
//  Created by eleves on 2017-10-10.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation
import UIKit


// Entity that represents each card
class Card {

    var id: String!
    var value: Int!
    var suit: String!
    var image: UIImage!
    
    // Constructor to a new card
    init(value: Int!, suit: String!) {
        self.id = "\(value!)\(suit!)"
        
        self.value = value
        self.suit = suit
        
        self.image = UIImage(named: id)
    }

    
    var stringValue: String {
        return "Card(id:\(id!))"
    }

    // Compare the cards by id
    func equalsTo(card: Card) -> Bool {
        return (card.id == id)
    }
    
    
}
