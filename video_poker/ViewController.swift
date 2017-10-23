//
//  ViewController.swift
//  video_poker
//
//  Created by eleves on 2017-10-10.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

// Main ViewController of the application
class ViewController: UIViewController {
    
    
    //MARK: Outlets
    // Score
    @IBOutlet weak var labelCredit: UILabel!
    @IBOutlet weak var labelBet: UILabel!
    @IBOutlet weak var labelHand: UILabel!
    // Score
    // Cards
    @IBOutlet weak var card1Background: UIView!
    @IBOutlet weak var card2Background: UIView!
    @IBOutlet weak var card3Background: UIView!
    @IBOutlet weak var card4Background: UIView!
    @IBOutlet weak var card5Background: UIView!
    
    @IBOutlet weak var labelCard1Hold: UILabel!
    @IBOutlet weak var labelCard2Hold: UILabel!
    @IBOutlet weak var labelCard3Hold: UILabel!
    @IBOutlet weak var labelCard4Hold: UILabel!
    @IBOutlet weak var labelCard5Hold: UILabel!
    
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
    // Cards
    // Controller
    @IBOutlet weak var betSlider: UISlider!
    @IBOutlet weak var buttonDeal: UIButton!
    @IBOutlet weak var labelButton: UILabel!
    // Controller
    
    // Instance of the Game "Manager"    
    let pokerGame = PokerGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the ViewController as implamentation of the delegate pattern
        pokerGame.delegate = self
        
        pokerGame.createDeckOfCards()
        
        // Initialize the slots
        pokerGame.cardSlots = [Slot(uiImageView: card1, backgroundView: card1Background, labelHold: labelCard1Hold),
                               Slot(uiImageView: card2, backgroundView: card2Background, labelHold: labelCard2Hold),
                               Slot(uiImageView: card3, backgroundView: card3Background, labelHold: labelCard3Hold),
                               Slot(uiImageView: card4, backgroundView: card4Background, labelHold: labelCard4Hold),
                               Slot(uiImageView: card5, backgroundView: card5Background, labelHold: labelCard5Hold)]
        
        // Visual attributes to the cards and the card's "background"
        setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
        
        // Set the chip icon to the slider
        var image = UIImage(named: "chip")
        image = resizeImage(image: image!, newWidth: CGFloat(30))
        betSlider.setThumbImage(image!, for: UIControlState.normal)
        
        // Set the intial min and max value to the slider
        betSlider.maximumValue = 0.0
        betSlider.maximumValue = Float(pokerGame.totalCredit)
        
        // Set the current bet and credit value
        labelBet.text = String(pokerGame.totalBet)
        labelCredit.text = String(pokerGame.totalCredit)
    }
    
    //MARK: Actions
    // Deal button action: shuffle, animation, bet and components status update
    @IBAction func doDeal(_ sender: UIButton) {
        if pokerGame.round == 0 && pokerGame.totalCredit == 0 {
            //Show alert controller "asking for money"
            let alertController = moreCreditAlertController()
            present(alertController, animated: true, completion: nil)
            buttonDeal.isEnabled = true
        } else {
            sender.isEnabled = false
            
            // If it's not the final round
            if pokerGame.round <= 1 {
                // If the user did't bet
                if pokerGame.totalBet == 0 {
                    let alertController = shouldBetAlertController()
                    present(alertController, animated: true, completion: nil)
                    buttonDeal.isEnabled = true
                } else {
                    // If it's the initial round
                    if pokerGame.round == 0 {
                        pokerGame.bet()
                        labelCredit.text = String(pokerGame.totalCredit)
                        labelBet.text = String(pokerGame.totalBet)
                        // Disable the slider
                        betSlider.isEnabled = false
                    }
                    didPlay()
                }
            } else {
                
                labelHand.text = ""
                
                // If there is still credit
                if pokerGame.totalCredit > 0 {
                    pokerGame.resetGame()
                    setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
                    
                    enableCardSelection(value: true)
                    
                    pokerGame.round = 0
                    
                    doDeal(sender)
                } else {
                    //Show alert controller "asking for money"
                    let alertController = moreCreditAlertController()
                    present(alertController, animated: true, completion: nil)
                    buttonDeal.isEnabled = true
                }
            }
        }
    }
    
    // Card selection action: select a slot
    @IBAction func selectCard(_ sender: UIButton) {
        let slot = pokerGame.cardSlots[sender.tag - 1]
        didSelectCard(slot: slot)
    }
    
    // Bet Slider "event": update the bet
    @IBAction func betSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        labelBet.text = String(currentValue)
        pokerGame.setBet(total: currentValue)
    }
    
    // Alert controller to "force" a bet
    func shouldBetAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""),
                                                message: NSLocalizedString("You should bet to deal!", comment: ""), preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        return alertController
    }
    
    // Alert controller to warn that the credits is over
    func noMoreCreditsAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""),
                                                message: NSLocalizedString("You don't have credits. Select deal to buy more!", comment: ""), preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        return alertController
    }
    
    // Alert controller "asking for money"
    func moreCreditAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: NSLocalizedString("You need credit", comment: ""),
                                                message: NSLocalizedString("Do you want to buy more $1000?", comment: ""), preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
            action in
            self.pokerGame.resetGame()
            self.pokerGame.totalCredit = 1000
            UserDefaults.standard.set(self.pokerGame.totalCredit, forKey: "totalCredit")
            self.setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
            
            self.enableCardSelection(value: true)
            
            self.pokerGame.round = 0
            self.pokerGame.totalBet = 0
            
            self.betSlider.isEnabled = true
            self.labelButton.text = NSLocalizedString("Deal", comment: "")
            
            self.betSlider.maximumValue = 0.0
            self.betSlider.maximumValue = Float(self.pokerGame.totalCredit)
            
            self.labelBet.text = String(self.pokerGame.totalBet)
            self.labelCredit.text = String(self.pokerGame.totalCredit)
            self.buttonDeal.isEnabled = true
        })
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default, handler: {
            action in
            self.pokerGame.setBackCards()
            self.buttonDeal.isEnabled = true
        })
        alertController.addAction(noAction)
        
        return alertController
    }
    
}

//MARK: ViewController's Style
extension ViewController {
    
    func enableCardSelection(value: Bool!) {
        buttonCard1.isEnabled = value
        buttonCard2.isEnabled = value
        buttonCard3.isEnabled = value
        buttonCard4.isEnabled = value
        buttonCard5.isEnabled = value
    }
    
    // Resize the image to the slider
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //MARK: Card's Style
    func setCardStyle(radius r: CGFloat, borderWidth w: CGFloat, borderColor c: CGColor, bgColor g: CGColor!) {
        for slot in pokerGame.cardSlots {
            slot.uiImageView.clipsToBounds = true
            slot.uiImageView.layer.cornerRadius = r
            slot.uiImageView.layer.borderWidth = w
            slot.uiImageView.layer.borderColor = c
            slot.uiImageView.layer.backgroundColor = g
            
            slot.backgroundView.clipsToBounds = true
            slot.backgroundView.layer.cornerRadius = r
            slot.backgroundView.layer.borderColor = c
            slot.backgroundView.backgroundColor = UIColor.clear
            
            slot.labelHold.isHidden = true
        }
    }
    
    // Select 4 random images images to the animation
    func imagesToAnimation() -> [UIImage]! {
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

// MARK: PokerGameDelegate
// Extension of the ViewController for the delegate pattern with the Game "Manager"
extension ViewController: PokerGameDelegate {
    
    func didPlay() {
        // Show the animation
        doAnimation()
        
        // Show the selected cards after the animation finish
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(displayRandomCards), userInfo: nil, repeats: false)
        
        pokerGame.hasStarted = true
    }
    
    func doAnimation() {
        for slotAnimation in pokerGame.cardSlots {
            if !slotAnimation.isSelected {
                let randomImages = imagesToAnimation()
                slotAnimation.uiImageView.animationDuration = 0.2
                slotAnimation.uiImageView.animationRepeatCount = 4
                slotAnimation.uiImageView.animationImages = randomImages!
                
                slotAnimation.uiImageView.startAnimating()
            }
        }
    }
    
    @objc func displayRandomCards() {
        // Stops the animation and set the random cards to the slot
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
        
        // If it is the second round
        if pokerGame.round == 1 {
            if let hand = pokerGame.verifyHands() {
                let total = pokerGame.totalBet * hand.multiplier
                pokerGame.totalCredit += total
                UserDefaults.standard.set(self.pokerGame.totalCredit, forKey: "totalCredit")
                pokerGame.totalBet = 0
                labelHand.text = hand.handName
            } else {
                labelHand.text = ""
                pokerGame.totalBet = 0
            }
            
            // Update the card's button
            enableCardSelection(value: false)
            
            // Update the slider
            betSlider.maximumValue = 0.0
            betSlider.maximumValue = Float(pokerGame.totalCredit)
            betSlider.isEnabled = true
            
            if pokerGame.totalCredit == 0 {
                //Show alert controller informing that the credits is over
                let alertController = noMoreCreditsAlertController()
                present(alertController, animated: true, completion: nil)
                betSlider.isEnabled = false
                labelButton.text = NSLocalizedString("Reset", comment: "")
            }
        }
        
        pokerGame.round += 1
        // Set the current score
        labelBet.text = String(pokerGame.totalBet)
        labelCredit.text = String(pokerGame.totalCredit)
        buttonDeal.isEnabled = true
    }
    
    // When a card is selected
    func didSelectCard(slot: Slot!) {
        if pokerGame.hasStarted! {
            if slot.isSelected! {
                slot.backgroundView.backgroundColor = UIColor.clear
                slot.labelHold.isHidden = true
                slot.isSelected = false
            } else {
                didResetCard(slot: slot, isSelected: true)
            }
        }
    }
    
    // When a card needs to be "restarted"
    func didResetCard(slot: Slot!, isSelected: Bool!) {
        if isSelected! {
            slot.backgroundView.backgroundColor = UIColor(red: 247/255, green: 204/255, blue: 75/255, alpha: 1)
            slot.labelHold.isHidden = false
            slot.isSelected = true
        } else {
            slot.backgroundView.backgroundColor = UIColor.clear
            slot.labelHold.isHidden = true
            slot.isSelected = false
        }
    }
    
}

