//
//  AudioPlayer.swift
//  Match3
//
//  Created by Andrey on 14.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit
import AVFoundation

final class AudioPlayer: NSObject {
    static let sharedInstance = AudioPlayer()
    
    var audioPlayer = AVAudioPlayer()
    var audioPlayerFon = AVAudioPlayer()
    
    func setMusic(nameSound:String,type:String,loop:Int){
        do{
            let file = Bundle.main.path(forResource: nameSound, ofType: type)
            let url = URL(fileURLWithPath: file!)
            audioPlayer = try AVAudioPlayer(contentsOf:url)
            audioPlayer.numberOfLoops = loop
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch{print("Error")}
    }
    
    func setMusicFon(nameSound:String,type:String,loop:Int){
        do{
            let file = Bundle.main.path(forResource: nameSound, ofType: type)
            let url = URL(fileURLWithPath: file!)
            audioPlayerFon = try AVAudioPlayer(contentsOf:url)
            audioPlayerFon.numberOfLoops = loop
            audioPlayerFon.prepareToPlay()
            audioPlayerFon.play()
        }catch{print("Error")}
    }
}

