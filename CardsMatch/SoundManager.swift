//
//  SoundManager.swift
//  CardsMatch
//
//  Created by Media Davarkhah on 5/23/1399 AP.
//  Copyright © 1399 Media Davarkhah. All rights reserved.
//

import Foundation
import AVFoundation
class SoundManager{
    
    // creat an AVPLayer object
    var audioPlayer : AVAudioPlayer?
    
    enum soundEffect{
        case flip
        case matched
        case notMatched
        case shuffle
    }
    
    func playSound(effect : soundEffect){
        
        var soundFileName : String
        
        switch effect {
        
        case .flip:
            soundFileName = "cardflip"
        case .matched:
            soundFileName = "dingcorrect"
        case .notMatched:
            soundFileName = "dingwrong"
        case .shuffle:
            soundFileName = "shuffle"
            
        }
        // Get the path to the resource
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath : bundlePath!)
        
        do{
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer!.play()
        }
        
        catch{
            
            print("//error :couldn't find the path")
            return
        }
        
        
    }
    
}
