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
    
    @IBOutlet weak var card1Background: UIView!
    @IBOutlet weak var card2Background: UIView!
    @IBOutlet weak var card3Background: UIView!
    @IBOutlet weak var card4Background: UIView!
    @IBOutlet weak var card5Background: UIView!
    var arrOfBackgrounds: [UIView]!
    
    // MARK: Game "Manager"
    let pokerGame = PokerGame()
    var cardSlots: [Slot?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokerGame.delegate = self
        pokerGame.hasStarted = false
        
        pokerGame.createDeckOfCards()
        pokerGame.cardSlots = [Slot(uiImageView: card1), Slot(uiImageView: card2), Slot(uiImageView: card3), Slot(uiImageView: card4), Slot(uiImageView: card5)]
        arrOfBackgrounds = [card1Background, card2Background, card3Background, card4Background, card5Background]
        
        setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
        setCardSlotStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor)
        
        var image = UIImage(named: "chip.png")
        image = resizeImage(image: image!, newWidth: CGFloat(30))
        betSlider.setThumbImage(image!, for: UIControlState.normal)
        //betSlider.setThumbImage(UIImage(named: "chip"), for: UIControlState.highlighted)
        
        betSlider.maximumValue = 0.0
        betSlider.maximumValue = Float(pokerGame.totalCredit)
        
        labelCredit.text = String(pokerGame.totalCredit)
        labelBet.text = String(pokerGame.totalBet)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
                didPlay()
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
                
                let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
                    action in
                    self.pokerGame.totalCredit = 1000
                    self.pokerGame.resetGame()
                    self.setCardStyle(radius: 10, borderWidth: 0.5, borderColor: UIColor.black.cgColor, bgColor: UIColor.yellow.cgColor)
                    
                    self.enableCardSelection(value: true)
                    
                    self.pokerGame.totalBet = 0
                    self.pokerGame.round = 0
                    
                    self.betSlider.maximumValue = 0.0
                    self.betSlider.maximumValue = Float(self.pokerGame.totalCredit)
                    self.labelCredit.text = String(self.pokerGame.totalCredit)
                    self.labelBet.text = String(self.pokerGame.totalBet)
                })
                alertController.addAction(yesAction)
                
                let noAction = UIAlertAction(title: "No", style: .default, handler: {
                    action in
                    self.pokerGame.setBackCards()
                })
                alertController.addAction(noAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        let slot = pokerGame.cardSlots[sender.tag - 1]
        didSelectCard(slot: slot)
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
    
    //MARK: Card's Style
    func setCardStyle(radius r: CGFloat, borderWidth w: CGFloat, borderColor c: CGColor, bgColor g: CGColor!) {
        for slotImageView in pokerGame.cardSlots {
            slotImageView.uiImageView.clipsToBounds = true
            slotImageView.uiImageView.layer.cornerRadius = r
            slotImageView.uiImageView.layer.borderWidth = w
            slotImageView.uiImageView.layer.borderColor = c
            slotImageView.uiImageView.layer.backgroundColor = g
        }
    }
    
    func setCardSlotStyle(radius r: CGFloat, borderWidth w: CGFloat?, borderColor c: CGColor)  {
        for bgView in arrOfBackgrounds {
            bgView.clipsToBounds = true
            bgView.layer.cornerRadius = r
            bgView.layer.borderWidth = w ?? 0
            bgView.layer.borderColor = c
        }
    }
    
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

// Extension of the ViewController for the delegate pattern with the Game "Manager"
extension ViewController: PokerGameDelegate {
    
    func didPlay() {
        doAnimation()
        
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
    
    func didSelectCard(slot: Slot!) {
        if pokerGame.hasStarted! {
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
    
    func didResetCard(slot: Slot!) {
        slot.uiImageView.layer.borderWidth = 0.5
        slot.uiImageView.layer.borderColor = UIColor.black.cgColor
        slot.isSelected = false
    }
    
}

