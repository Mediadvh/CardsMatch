//
//  ModelCard.swift
//  CardsMatch
//
//  Created by Media Davarkhah on 5/14/1399 AP.
//  Copyright © 1399 Media Davarkhah. All rights reserved.
//

import Foundation

class ModelCard{
    
    // A function that generates random pair of cards
    func getCards()->[Card]{
        var Random = [Int]()
        var GeneratedCards = [Card]()
        // generate 8 random numbers
        repeat
        {
            let rNumber = Int.random(in: 1...13)
        
        // make two card objects with the random number
            if(!Random.contains(rNumber))
            {
                Random += [rNumber]
                let FirstCard = Card()
                let SecondCard = Card()
                FirstCard.imageName = "card\(rNumber)"
                SecondCard.imageName = "card\(rNumber)"
                print(rNumber)
                // add it to the array
                GeneratedCards += [FirstCard,SecondCard]
            }
        }while GeneratedCards.count < 16
        
        // shuffle
        GeneratedCards.shuffle()
        // return the cards
            return GeneratedCards
        
    }
    
}
