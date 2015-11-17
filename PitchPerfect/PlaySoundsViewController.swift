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
    
    // Defines a variable to catch the pushed audio from the record view controller.
    var receivedAudio:RecordedAudio!
    
    // Defines an instance of audio engine.
    var audioEngine:AVAudioEngine!
    
    // Defines an instance of audio file.
    var audioFile:AVAudioFile!
    
    // Defines an instance of an audio player node. This is global to allow external stopping.
    let audioPlayerNode = AVAudioPlayerNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define an auto player with the file path that was passed in from
        // the first view.
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: ".wav")
        audioPlayer.enableRate = true
        
        // Define an auto player with the file path that was passed in from
        // the first view. This player is used in the echo function.
        audioPlayerEcho = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: ".wav")
        audioPlayerEcho.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    // Defines a function that resets all audio.
    func resetAudio() {
        // Stop the player, node and the engine. Reset the engine.
        audioPlayer.stop()
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    //# MARK: - Audio modulation functions
    
    // Defines a function that will play the audio with the input
    // pitch and rate.
    func playAudioWithEffect (Pitch : Float, Rate : Float) {
        // Define an instance of unit time pitch for the desired rate effect.
        let changeEffect = AVAudioUnitTimePitch()
        
        // Reset the audio player.
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
    
    // Defines a function that will play the audio with reverb.
    func playAudioWithReverb (Reverb : Float) {
        // Defines the change effect instance.
        let changeEffect = AVAudioUnitReverb ()
        
        // Reset the audio player.
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
    
    // Defines a function that will play the audio with echo.
    func playAudioWithEcho (Delay : Double) {
        // Reset the audio player.
        resetAudio ()

        // Stop the player and the engine. Reset the engine.
        audioPlayerEcho.stop()
        audioPlayerEcho.currentTime = 0
        audioPlayer.play()
        
        let delay:NSTimeInterval = Delay //ms
        var playtime:NSTimeInterval
        
        // Define the playtime based on the current time and the 
        // input delay.
        playtime = audioPlayerEcho.deviceCurrentTime + delay
        
        // Set the current time to 0 and the volume to max.
        audioPlayerEcho.currentTime = 0
        audioPlayerEcho.volume = 1.0
        
        // Schedule the audio playing.
        audioPlayerEcho.playAtTime(playtime)
    }
    
    //# MARK: - All IB object functions
    
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
