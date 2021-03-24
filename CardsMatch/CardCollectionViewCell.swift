//
//  CardCollectionViewCell.swift
//  CardsMatch
//
//  Created by Media Davarkhah on 5/15/1399 AP.
//  Copyright © 1399 Media Davarkhah. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var FrontImageView: UIImageView!
    
    @IBOutlet weak var BackImageView: UIImageView!
    
    
    var card : Card?
    
    func configureCell(card :Card){
        
        // Store the card
        self.card = card
        
        // Set the front image view
        FrontImageView.image = UIImage ( named: card.imageName)
        
        // Reset the state of the cell by checking the flipped status of the card and then showing the front or the back imageview accordingly
        
        if card.matched == true {
            BackImageView.alpha = 0
            FrontImageView.alpha = 0
            return
        }
        else {
            BackImageView.alpha = 1
            FrontImageView.alpha = 1
        }
    
        if card.flipped == true {
            // Show the front image view
            flipUp(speed: 0)
        }
        else {
            // Show the back image view
            flipDown(speed: 0, delay: 0)
        }
    }
    
    func flipUp(speed : TimeInterval = 0.3){
        
        
        UIView.transition(from: BackImageView, to: FrontImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        
        // set the state
        card?.flipped = true
        
    }
    
    func flipDown(speed : TimeInterval = 0.3, delay : TimeInterval = 0.5){
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            UIView.transition(from: self.FrontImageView, to: self.BackImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        
        }
        // set the state
        card?.flipped = false
    }
    
    func remove(flippedCard : IndexPath ) {
        
        // make the image views invisibale
        BackImageView.alpha = 0
        
        //fades out
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: { self.FrontImageView.alpha = 0}, completion: nil)
    
    }
}
