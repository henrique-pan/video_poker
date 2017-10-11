//
//  ViewController.swift
//  video_poker
//
//  Created by eleves on 2017-10-10.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //MARK: Outlets
    @IBOutlet weak var card1: UIImageView!
    @IBOutlet weak var card2: UIImageView!
    @IBOutlet weak var card3: UIImageView!
    @IBOutlet weak var card4: UIImageView!
    @IBOutlet weak var card5: UIImageView!
    @IBOutlet weak var buttonBet25: UIButton!
    @IBOutlet weak var buttonBet100: UIButton!
    @IBOutlet weak var buttonAllIn: UIButton!
    
    // MARK: Game "Manager"
    let pokerGame = PokerGame()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokerGame.hasStarted = false
        
        pokerGame.createDeckOfCards()
        
        pokerGame.cardSlots = [Slot(uiImageView: card1), Slot(uiImageView: card2), Slot(uiImageView: card3), Slot(uiImageView: card4), Slot(uiImageView: card5)]
        setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
    }

    @IBAction func selectCard(_ sender: UIButton) {
        didSelectCard(slotIndex: (sender.tag - 1))
    }
    
    @IBAction func doDeal(_ sender: UIButton) {
        doDeal()
    }
    
    
    @IBAction func doBet(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            pokerGame.addBet(total: 25)
        case 2:
            pokerGame.addBet(total: 100)
        case 3:
            pokerGame.addBet(total: pokerGame.totalCredit)
        default:
            break
        }
        
        if pokerGame.totalCredit < 25 {
            buttonBet25.isEnabled = false
        }
        
        if pokerGame.totalCredit < 100 {
            buttonBet100.isEnabled = false
        }
        
        if pokerGame.totalCredit < 25 && pokerGame.totalCredit < 100 {
            buttonAllIn.isEnabled = false
        }
        
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
        pokerGame.resetGame()
        setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
        buttonBet25.isEnabled = true
        buttonBet100.isEnabled = true
        buttonAllIn.isEnabled = true
    }
}

//MARK: ViewController Style
extension ViewController {
    
    //MARK: Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    //MARK: Card's slot Style
    func setCardStyle(radius r: CGFloat, borderWidth w: CGFloat, borderColor c: CGColor, bgColor g: CGColor!) {
        for slotImageView in pokerGame.cardSlots {
            slotImageView.uiImageView.clipsToBounds = true
            slotImageView.uiImageView.layer.cornerRadius = r
            slotImageView.uiImageView.layer.borderWidth = w
            slotImageView.uiImageView.layer.borderColor = c
            slotImageView.uiImageView.layer.backgroundColor = g
        }
    }
    
    func doAnimation() {
        for slotAnimation in pokerGame.cardSlots {
            if !slotAnimation.isSelected {
                let randomImages = imagesToAnimation()
                prepareAnimations(slot: slotAnimation.uiImageView, duration: 0.2, repeating: 4, cards: randomImages!)
                slotAnimation.uiImageView.startAnimating()
            }
        }
    }
    
    private func prepareAnimations(slot: UIImageView, duration d: Double, repeating r: Int, cards c: [UIImage]) {
        slot.animationDuration = d
        slot.animationRepeatCount = r
        slot.animationImages = c
    }
    
    private func imagesToAnimation() -> [UIImage]! {
        var images = [UIImage]()
        for _ in 1...4 {
            let randomIndex = Int(arc4random_uniform(UInt32(pokerGame.totalCardsOnDeck)))
            if let card = pokerGame.cardAt(index: randomIndex) {
                images.append(card.image)
            }
        }
        return images
    }
}

// Extension of the ViewController for the delegate pattern with the Game "Manager"
extension ViewController: PokerGameDelegate {
    
    func doDeal() {
        doAnimation()
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(displayRandomCards), userInfo: nil, repeats: false)
        
        pokerGame.hasStarted = true
        buttonBet25.isEnabled = false
        buttonBet100.isEnabled = false
        buttonAllIn.isEnabled = false
        
        
    }
    
    @objc func displayRandomCards() {
        for slot in pokerGame.cardSlots {
            if !slot.isSelected {
                let randomIndex = Int(arc4random_uniform(UInt32(pokerGame.totalCardsOnDeck)))
                slot.uiImageView.stopAnimating()
                if let card = pokerGame.cardAt(index: randomIndex) {
                    slot.uiImageView.image = card.image
                    slot.card = card
                    pokerGame.deckOfCards.remove(at: randomIndex)
                }
            }
        }
        
        if let hand = pokerGame.verifyHands() {
            print(hand.handName)
            print(hand.multiplier)
            
            let total = pokerGame.totalBet * hand.multiplier
            pokerGame.totalCredit += total
            pokerGame.totalBet = 0
        }
        
        print("TOTAL CREDIT: \(pokerGame.totalBet)")
        print("TOTAL CREDIT: \(pokerGame.totalCredit)")
    }
    
    func didSelectCard(slotIndex: Int!) {
        if pokerGame.hasStarted! {
            let slot = pokerGame.cardSlots[slotIndex]
            if slot.isSelected! {
                slot.uiImageView.layer.borderWidth = 0.5
                slot.uiImageView.layer.borderColor = UIColor.black.cgColor
                slot.isSelected = false
            } else {
                slot.uiImageView.layer.borderWidth = 1.5
                slot.uiImageView.layer.borderColor = UIColor.blue.cgColor
                slot.isSelected = true
            }
        }
    }
    
}

