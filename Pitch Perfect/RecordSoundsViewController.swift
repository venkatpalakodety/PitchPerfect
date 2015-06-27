//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Venkata Palakodety on 6/6/15.
//  Copyright (c) 2015 Venkata Palakodety. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var currentState:RecordingState = RecordingState.Stop
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        //Initialize the recording state to Stop.
        currentState = RecordingState.Stop
        
        //Change the recordingStatusLabel.
        recordingStatusLabel.text = "Tap to Record"
        
        //Change the image to microphone.
        self.recordButton.setImage(UIImage(named:"microphone.png"),forState:UIControlState.Normal)
        
        //Hide the stop button.
        stopButton.hidden = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        //Display the stop button.
        stopButton.hidden = false
        
        //Call recording functions based on the recording state.
        if(currentState == RecordingState.Stop)
        {
            recordAudio()
        }
        else if(currentState == RecordingState.Record)
        {
            pauseRecording()
        }
        else if(currentState == RecordingState.Pause)
        {
            resumeRecording()
        }
    }

    func recordAudio() {
        //Initialize the recording state to Record.
        currentState = RecordingState.Record
        
        //Change the recordingStatusLabel to show that recording is in progress.
        recordingStatusLabel.text = "Recording in Progress. Tap to Pause"
        
        //Display the stop button.
        stopButton.hidden = false

        //Create an Audio file for recording.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //Create an audio session to record and play the audio.
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //Output the audio to speakerphone.
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        
        //Create a delegate of AVAudioRecorder that records audio.
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func pauseRecording() {
        //Initialize the recording state to Pause.
        currentState = RecordingState.Pause
        
        //Change the microphone image to a pause image.
        self.recordButton.setImage(UIImage(named:"pause.png"),forState:UIControlState.Normal)

        //Change the recordingStatusLabel to show that recording is paused.
        recordingStatusLabel.text = "Paused Recording. Tap to Resume"
        
        //Display the stop button.
        stopButton.hidden = false

        //Pause the recording.
        audioRecorder.pause()
    }
    
    func resumeRecording() {
        //Initialize the recording state to Record.
        currentState = RecordingState.Record
        
        //Change the microphone image to a microphone image.
        self.recordButton.setImage(UIImage(named:"microphone.png"),forState:UIControlState.Normal)
        
        //Change the recordingStatusLabel to show that recording is in progress.
        recordingStatusLabel.text = "Recording in Progress. Tap to Pause"

        //Display the stop button.
        stopButton.hidden = false

        //Record the audio.
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            //Save the Recording Audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
            //Switch to the next scene aka perform Segue.
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            //Print a message that the recording was not successful.
            recordingStatusLabel.text = "Unable to record. Tap to Record"
            stopButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Prepare for Segue when the recording is stopped.
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        //Stop the audio recording and de-activate the audioSession.
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

