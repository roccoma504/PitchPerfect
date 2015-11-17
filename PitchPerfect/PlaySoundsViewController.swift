//
//  Playsounds.swift
//  PitchPerfect
//
//  Created by Matthew Rocco on 11/15/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    

    
    // Define an audio player.
    var audioPlayer:AVAudioPlayer!
    var audioPlayerEcho:AVAudioPlayer!
    
    // Define a variable to catch the pushed audio from the record view controller.
    var receivedAudio:RecordedAudio!
    
    // Define an instance of audio engine.
    var audioEngine:AVAudioEngine!
    
    // Define an instance of audio file.
    var audioFile:AVAudioFile!
    
    // Define an instance of an audio player node. This is global to allow external stopping.
    let audioPlayerNode = AVAudioPlayerNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: ".wav")
        audioPlayer.enableRate = true
        
        audioPlayerEcho = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: ".wav")
        audioPlayerEcho.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    func resetAudio() {
        
        // Stop the player and the engine. Reset the engine.
        audioPlayer.stop()
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithEffect (Pitch : Float, Rate : Float) {
        
        // Define an instance of unit time pitch for the desired rate effect.
        let changeEffect = AVAudioUnitTimePitch()
        
        resetAudio()
        
        // Define audio engine locally.
        audioEngine = AVAudioEngine()
        
        // Set the effects based on the inputs.
        changeEffect.rate = Rate
        changeEffect.pitch = Pitch
        
        // Attatch and connect the nodes.
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(changeEffect)
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        
        // Schedule the file for playing
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        // Start the audio engine. If this is nil, something horrible went wrong and we should crash.
        try! audioEngine.start()
        
        // Play the audio file.
        audioPlayerNode.play()
        
    }
    
    func playAudioWithReverb (Reverb : Float) {
        
        let changeEffect = AVAudioUnitReverb ()
        
        resetAudio ()
        
        // Define audio engine locally.
        audioEngine = AVAudioEngine()
        
        // Set reverb to cathedral.
        changeEffect.wetDryMix = Reverb
        
        // Attatch and connect the nodes.
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(changeEffect)
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        
        // Schedule the file for playing
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        // Start the audio engine. If this is nil, something horrible went wrong and we should crash.
        try! audioEngine.start()
        
        // Play the audio file.
        audioPlayerNode.play()
        
    }
    
    func playAudioWithEcho (Delay : Double) {
        
        resetAudio ()

        // Stop the player and the engine. Reset the engine.
        audioPlayerEcho.stop()
        audioPlayerEcho.currentTime = 0;
        audioPlayer.play()
        
        let delay:NSTimeInterval = Delay //ms
        var playtime:NSTimeInterval
        playtime = audioPlayerEcho.deviceCurrentTime + delay
        audioPlayerEcho.currentTime = 0
        audioPlayerEcho.volume = 1.0;
        audioPlayerEcho.playAtTime(playtime)
        
    }
    
    
    @IBAction func stopButtonPress(sender: AnyObject) {
        // Stop the audio player early.
        audioPlayerNode.stop()
    }
    
    @IBAction func slowButtonPress(sender: AnyObject) {
        audioPlayerNode.stop()
        playAudioWithEffect(1.0, Rate: 1/2)
    }
    
    @IBAction func fastButtonPress(sender: AnyObject) {
        audioPlayerNode.stop()
        playAudioWithEffect(1.0, Rate: 2.0)
    }
    
    @IBAction func highButtonPress(sender: AnyObject) {
        audioPlayerNode.stop()
        playAudioWithEffect(1000.0, Rate: 1.0)
    }
    
    @IBAction func lowButtonPress(sender: AnyObject) {
        audioPlayerNode.stop()
        playAudioWithEffect(-1000.0, Rate: 1.0)
    }
    
    @IBAction func reverbButtonPress(sender: AnyObject) {
        playAudioWithReverb(75.0)
    }
    
    @IBAction func echoButtonPress(sender: AnyObject) {
        playAudioWithEcho(0.5)
    }
    
}

