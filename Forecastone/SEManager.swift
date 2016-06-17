//
//  SEManager.swift
//  Forecastone
//
//  Created by Satoru Hosaka on 2015/07/07.
//  Copyright (c) 2015年 Satoru Hosaka. All rights reserved.
//

import Foundation
import AVFoundation

class SEManager: NSObject,AVAudioPlayerDelegate {
    var soundArray: [AVAudioPlayer] = []
    
    func sePlay(soundName: String) {
        let url = NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent(soundName)
        do {
            let player = try AVAudioPlayer(contentsOfURL: url)
            soundArray.append(player)
            player.delegate = self
            player.numberOfLoops = 0
            player.play()
        }catch{
            print("Error!")
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        let i: Int = soundArray.indexOf(player)!
        soundArray.removeAtIndex(i)
    }
}