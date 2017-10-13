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
    
    @IBOutlet weak var buttonCard1: UIButton!
    @IBOutlet weak var buttonCard2: UIButton!
    @IBOutlet weak var buttonCard3: UIButton!
    @IBOutlet weak var buttonCard4: UIButton!
    @IBOutlet weak var buttonCard5: UIButton!    
    
    @IBOutlet weak var betSlider: UISlider!
    @IBOutlet weak var buttonDeal: UIButton!
    
    @IBOutlet weak var labelCredit: UILabel!
    @IBOutlet weak var labelBet: UILabel!
    @IBOutlet weak var labelHand: UILabel!
    
    // MARK: Game "Manager"
    let pokerGame = PokerGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokerGame.hasStarted = false
        
        pokerGame.createDeckOfCards()
        
        pokerGame.cardSlots = [Slot(uiImageView: card1), Slot(uiImageView: card2), Slot(uiImageView: card3), Slot(uiImageView: card4), Slot(uiImageView: card5)]
        
        setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
        
        betSlider.maximumValue = 0.0
        betSlider.maximumValue = Float(pokerGame.totalCredit)
        
        labelCredit.text = String(pokerGame.totalCredit)
        labelBet.text = String(pokerGame.totalBet)
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        didSelectCard(slotIndex: (sender.tag - 1))
    }
    
    @IBAction func doDeal(_ sender: UIButton) {
        print("ROUND: \(pokerGame.round)")
        if pokerGame.round <= 1 {
            if pokerGame.totalBet == 0 {
                let alertController = UIAlertController(title: "Attention", message: "You should bet to deal!", preferredStyle: .alert)
                  
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            } else {
                if pokerGame.round == 0 {
                    pokerGame.bet()
                    labelCredit.text = String(pokerGame.totalCredit)
                    labelBet.text = String(pokerGame.totalBet)
                    betSlider.isEnabled = false
                }
                doDeal()
            }
        } else {
            
            labelHand.text = ""
            
            if pokerGame.totalCredit > 0 {
                pokerGame.resetGame()
                setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
                
                enableCardSelection(value: true)

                pokerGame.round = 0

                doDeal(sender)
            } else {
                let alertController = UIAlertController(title: "You need credit", message: "Do you want to buy more $1000?", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "Yes", style: .default, handler: {
                    action in
                    self.pokerGame.totalCredit = 1000
                    self.pokerGame.resetGame()
                    self.setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
                    
                    self.enableCardSelection(value: true)
                    
                    self.pokerGame.totalBet = 0
                    self.pokerGame.round = 0
                })
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func betSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        labelBet.text = String(currentValue)
        pokerGame.setBet(total: currentValue)
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
    
    func enableCardSelection(value: Bool!) {
        buttonCard1.isEnabled = value
        buttonCard2.isEnabled = value
        buttonCard3.isEnabled = value
        buttonCard4.isEnabled = value
        buttonCard5.isEnabled = value
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
        
        if pokerGame.round == 1 {
            if let hand = pokerGame.verifyHands() {
                let total = pokerGame.totalBet * hand.multiplier
                pokerGame.totalCredit += total
                pokerGame.totalBet = 0
                labelHand.text = hand.handName
            } else {
                labelHand.text = ""
                pokerGame.totalBet = 0
            }
            
            enableCardSelection(value: false)
            labelCredit.text = String(pokerGame.totalCredit)
            labelBet.text = String(pokerGame.totalBet)

            betSlider.maximumValue = 0.0
            betSlider.maximumValue = Float(pokerGame.totalCredit)
            betSlider.isEnabled = true
        }
        
        pokerGame.round += 1
        
        labelCredit.text = String(pokerGame.totalCredit)
        labelBet.text = String(pokerGame.totalBet)
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

