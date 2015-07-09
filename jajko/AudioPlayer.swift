//
//  AudioPlayer.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-27.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer : NSObject {
    typealias AudioPlayerCompletionClosure = (Void -> Void)
    /// The player.
    var avPlayer:AVAudioPlayer!

    private var currentClosure:AudioPlayerCompletionClosure?
    private var currentDelayTime:Double?
    
    class var sharedInstance : AudioPlayer {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : AudioPlayer? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AudioPlayer()
        }
        return Static.instance!
    }
    
    func play(fileName:String, delayTime:Double? = 0.0, completion:AudioPlayerCompletionClosure? = nil) {
        if avPlayer == nil || !avPlayer.playing {
            currentClosure = completion
            currentDelayTime = delayTime
            var error: NSError?
            if let fileURL:NSURL = NSBundle.mainBundle().URLForResource(fileName, withExtension: "caf") {
                self.avPlayer = AVAudioPlayer(contentsOfURL: fileURL, error: &error)
                if avPlayer == nil {
                    if let e = error {
                        println(e.localizedDescription)
                    }
                }
                avPlayer.delegate = self
                avPlayer.prepareToPlay()
                avPlayer.volume = 1.0
                avPlayer.play()
            } else {
                println("No file URL found for \(fileName).caf")
                self.avPlayer = nil
                currentClosure?()
            }
        } else {
            println("Player called while playing...")
        }
    }
    func stop() {
        if avPlayer.playing {
            avPlayer.stop()
        }
    }
    func toggle() {
        if avPlayer.playing {
            avPlayer.pause()
        } else {
            avPlayer.play()
        }
    }
}

// MARK: AVAudioPlayerDelegate
extension AudioPlayer : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.avPlayer = nil
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(currentDelayTime! * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            currentClosure?()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("\(error.localizedDescription)")
        self.avPlayer = nil
        currentClosure?()
    }
}
