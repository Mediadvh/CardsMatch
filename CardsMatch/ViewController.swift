//
//  ViewController.swift
//  CardsMatch
//
//  Created by Media Davarkhah on 5/12/1399 AP.
//  Copyright © 1399 Media Davarkhah. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    var soundEffect = SoundManager()
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var Getcards = ModelCard()
    var cardsArray = [Card]()
    var firstFlippedCard : IndexPath?
    
    var miliseconds: Int = 50 * 1000
    var timer :Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cardsArray = Getcards.getCards()
        CollectionView.dataSource = self
        CollectionView.delegate = self
        
        // initialize the timer
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        // it simply runs the timer on background so it doesn't stop when th UI is uptading
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // play shuffle sound
        soundEffect.playSound(effect: .shuffle)
    }
    // MARK: -Timer methods
    
    @objc func timerFired(){
        // Decrement the counter
        miliseconds -= 1
        // Update the Label
        let seconds:Double = Double(miliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        // Stop the Timer if it reaches zero
        if (miliseconds == 0){
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            // check if the user has cleared all the pairs
            checkForGameEnd()
            
        }
        
    }
    
    
    
    // MARK: -Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Number of Cards
        return cardsArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // generate a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell" , for: indexPath) as! CardCollectionViewCell
        
        // return the cell
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // generate a New cell
        let newCell = cell as? CardCollectionViewCell
        // configure the cell
        newCell?.configureCell(card: cardsArray[indexPath.row])
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // if the time's up don't let user flip cards
        if(miliseconds == 0){
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if(cell?.card?.flipped == false && cell?.card?.matched == false){
            
            // play flip sound
            soundEffect.playSound(effect: .flip)
            
            // flip the card up
            cell?.flipUp()
            
            // Check if this is the first card flipped up
            if(firstFlippedCard == nil){
                
                // Store the first card
                firstFlippedCard = indexPath
                
            }
            else{
                
                // Check for a match
                matchedCheck(indexPath)
                
                
            }
            
        }
        
        
    }
    // MARK: - Game Logic Methods
    
    func matchedCheck(_ secondFlippedCard : IndexPath ){
        
        // Get the two collection view cells that represent card one and two
        let cardOneCell = CollectionView.cellForItem(at: firstFlippedCard!) as? CardCollectionViewCell
        let cardTwoCell = CollectionView.cellForItem(at: secondFlippedCard) as? CardCollectionViewCell
        
        // Get two card objects for the two indicies and see if they match
        let cardOne = cardsArray[firstFlippedCard!.row]
        let cardTwo = cardsArray[secondFlippedCard.row]
        
        // compare the two cards
        if cardOne.imageName == cardTwo.imageName{
            
            // it's a match
            
            // play matched sound
            soundEffect.playSound(effect: .matched)
            
            // set the status
            cardOne.matched = true
            cardTwo.matched = true
            
            // the cards are a match
            cardOneCell?.remove(flippedCard: firstFlippedCard!)
            cardTwoCell?.remove(flippedCard: secondFlippedCard)
            // check if the user has won
            checkForGameEnd()
        }
            
            
        else {
            
            // It's not a match
            
            // play not matched sound
            soundEffect.playSound(effect: .notMatched)
            
            cardOne.flipped = false
            cardTwo.flipped = false
            
            // Flip them back over
            
          
            
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
        }
        
        // Reset the firstflippedcard property
        firstFlippedCard = nil
        
    }
    
    
    
    
    func checkForGameEnd(){
        
        // Assume the user has won loop through the cards to see if all of them are matched
        var hasWon = true
        
        for card in cardsArray{
            if card.matched == false{
                hasWon = false
                break
                
            }
            
        }
        
        if hasWon{
            
            // User has won , show an alert
            showAlert(title: "Congratulations" , message:"You won the game!" )
            
            timer?.invalidate()
        }
            
        else{
            // User hasn't won yet , check if there's any time left
            if miliseconds <= 0 {
                showAlert(title: "Time's Up", message: "sorry, better luck  next Time")
            }
        }
    }
    
    func showAlert(title:String,message:String){
        
        // create an alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a button and add it to the alert for the user to dismiss it
        let okAction = UIAlertAction(title: "Ok" ,style: .default ,handler: nil)
        alert.addAction(okAction)
        
        // Show the alert
        present(alert,animated: true,completion : nil )
        
    }
    
}
