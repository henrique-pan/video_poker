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
    
    //MARK: CARDS
    var cardSlots: [Slot]!
    var deckOfCards: [Card]! = []
    
    // MARK: Game Controller
    var hasStarted: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasStarted = false
        
        createDeckOfCards()
        
        cardSlots = [Slot(uiImageView: card1), Slot(uiImageView: card2), Slot(uiImageView: card3), Slot(uiImageView: card4), Slot(uiImageView: card5)]
        setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
    }
    
    func createDeckOfCards() {
        let suits = ["d", "h", "c", "s"]
        
        for suit in suits {
            for value in 1...13 {
                let newCard = Card(value: value, suit: suit)
                deckOfCards.append(newCard)
            }
        }
    }

    @IBAction func doDeal(_ sender: UIButton) {
        doAnimation()
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(displayRandomCards), userInfo: nil, repeats: false)
        
        hasStarted = true
    }
    
    @objc private func displayRandomCards() {
        
        for slot in cardSlots {
            if !slot.isSelected {
                let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
                slot.uiImageView.stopAnimating()
                slot.uiImageView.image = deckOfCards[randomIndex].image
                slot.card = deckOfCards[randomIndex]
                deckOfCards.remove(at: randomIndex)
            }
        }
    }
    
    
    @IBAction func selectCard(_ sender: UIButton) {
        print("Tag: \(sender.tag)")
        
        if hasStarted! {
            let slot = cardSlots[sender.tag - 1]
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
    
    func selectedCards() -> [Card]! {
        var selectedCards: [Card]! = []
        for slot in cardSlots {
            if slot.isSelected! {
                selectedCards.append(slot.card!)
            }
        }
        
        return selectedCards
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
        for slotImageView in cardSlots {
            slotImageView.uiImageView.clipsToBounds = true
            slotImageView.uiImageView.layer.cornerRadius = r
            slotImageView.uiImageView.layer.borderWidth = w
            slotImageView.uiImageView.layer.borderColor = c
            slotImageView.uiImageView.layer.backgroundColor = g
        }
    }
    
    func doAnimation() {
        for slotAnimation in cardSlots {
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
            let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
            images.append(deckOfCards[randomIndex].image)
        }
        return images
    }
}

