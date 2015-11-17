//
//  RecordSounds.swift
//  PitchPerfect
//
//  Created by Matthew Rocco on 11/15/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // Define all outlets
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    // Define an audio recorder. This will contain the recorded audio.
    var audioRecorder:AVAudioRecorder!
    
    // Defines a function to default the UI. This is used on initialization
    // and whenever the UI needs to be reset.
    func defaultUI() {
        recordLabel.text = "Press Microphone To Record"
        stopButton.hidden = true
        playButton.hidden = true
        pauseButton.hidden = true;
        recordButton.enabled = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Defines a function that is called when the audio is done recording.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        // If the audio finished recording successfully, save off the audio.
        // If not, log an error and default the UI.
        if (flag)
        {
            self.performSegueWithIdentifier("playSoundSegue", sender: RecordedAudio (Path: recorder.url, Title: recorder.url.lastPathComponent!))
        }
        else
        {
            print("Audio recording failed");
            defaultUI()
        }
    }
    
    //# MARK: - All IB object functions
    
    // Defines a function that is invoked when the record (microphone) button
    // is pressed.
    @IBAction func startButtonPressed(sender: AnyObject) {
        // Show the stop button.
        stopButton.hidden = false
        pauseButton.hidden = false
        
        // Change the label to say recording.
        recordLabel.text = "Recording..."
        
        // Disable the recording button.
        recordButton.enabled = false
        
        // Define the file path for the audio file. Print out the path.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "record.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // Defines a fuction that is invoked when the stop button is pressed.
    @IBAction func stopButtonPressed(sender: AnyObject) {
        // Stop the audio recorder.
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        // Default the UI so it is back to ready when the user returns.
        defaultUI()
    }
    
    // Defines a function that is invoked when the pause button is pressed.
    @IBAction func pauseButtonPressed(sender: AnyObject) {
        // Hide the pause button. Show the play button.
        pauseButton.hidden = true;
        playButton.hidden = false;
        
        // Pause the recording.
        audioRecorder.pause()
    }
    
    // Defines a function that is invoked when the play button is pressed.
    @IBAction func playButtonPressed(sender: AnyObject) {
        // Show the pause button. Hide the play button.
        pauseButton.hidden = false;
        playButton.hidden = true;
        
        // Resume recording.
        audioRecorder.record()
    }
    
    // Defines a function that is invoked when the stop button is pressed.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If the segue that is triggered is the "playSondSegue" then transistion
        // to the next view controller and pass the recorded data.
        if (segue.identifier == "playSoundSegue")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}
