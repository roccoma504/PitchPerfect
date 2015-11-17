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
    
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
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
        // Dispose of any resources that can be recreated.
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //
        if (flag)
        {
            let recordedAudio = RecordedAudio ()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("playSoundSegue", sender: recordedAudio)
        }
        else
        {
            print("Audio recording failed");
            defaultUI()
        }
    }
    
    @IBAction func startRecord(sender: AnyObject) {
        
        print("in record");
        
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
    
    @IBAction func stopRecord(sender: AnyObject) {
        
        NSLog("in stop");
        
        // Stop the audio recorder.
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        defaultUI()
    }
    
    @IBAction func pauseButtonPress(sender: AnyObject) {
        // Hide the pause button. Show the play button.
        pauseButton.hidden = true;
        playButton.hidden = false;
        
        // Pause the recording.
        audioRecorder.pause()
        
    }
    
    @IBAction func playButtonPressed(sender: AnyObject) {
        // Show the pause button. Hide the play button.
        pauseButton.hidden = false;
        playButton.hidden = true;
        
        // Resume recording.
        audioRecorder.record()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "playSoundSegue")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}

