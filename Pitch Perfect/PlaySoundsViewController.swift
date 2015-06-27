//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Venkata Palakodety on 6/8/15.
//  Copyright (c) 2015 Venkata Palakodety. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    @IBOutlet weak var stopEffectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate AVAudioPlayer.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        // Set the enableRate property of the audioPlayer to true.
        audioPlayer.enableRate = true
        
        // Instantiate AVAudioEngine.
        audioEngine = AVAudioEngine()
        
        // Instantiate AVAudioFile for reading the recorded file.
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        // Disable the stopEffect button, so we can enable it when a sound effect plays.
        stopEffectButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        // Play audio sloooooowly...
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        // Play audio fast
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        // Play like a chipmunk
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // Play like Darth Vader
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        // Play an echo of the recorded sound by delaying the sound
        var delaySoundEffect = AVAudioUnitDelay()
        delaySoundEffect.delayTime = 0.5
        playAudioWithSoundEffect(delaySoundEffect)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        // Play a reverb of the recorded sound by selecting the preset for a large room
        var reverbSoundEffect = AVAudioUnitReverb()
        reverbSoundEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeRoom)
        reverbSoundEffect.wetDryMix = 81
        playAudioWithSoundEffect(reverbSoundEffect)
    }
    
    func playAudioWithVariableRate(rate: Float) {
        // Stop playing the recorded audio.
        stopAudio(self)
        
        // Adjust the audioPlayer rate.
        audioPlayer.rate = rate
        
        // Play the audio.
        audioPlayer.play()
        
        // Enable the stop button for clicking again.
        stopEffectButton.enabled = true
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        // Stop playing the recorded audio.
        stopAudio(self)
        
        // Initialize the changePitchEffect variable.
        var changePitchEffect = AVAudioUnitTimePitch()
        
        // Adjust the pitch.
        changePitchEffect.pitch = pitch
        
        // Play the Audio with the variable pitch.
        playAudioWithSoundEffect(changePitchEffect)
    }
    
    func playAudioWithSoundEffect(effect: AVAudioNode) {
        // Stop playing the recorded audio.
        stopAudio(self)
        
        // Initialize the audioPlayerNode variable.
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        
        // Connect the audioPlayerNode.
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        // Call the scheduleFile function of the audioPlayerNode Instance.
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // Play the audio.
        audioPlayerNode.play()
        
        // Enable the stop button for clicking again.
        stopEffectButton.enabled = true
        
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        //Stop the audioPlayer.
        audioPlayer.stop()
        
        //Stop the audioEngine inorder to prevent overlap.
        audioEngine.stop()
        
        //Reset the audioEngine inorder to prevent overlap of sound effects.
        audioEngine.reset()
        
        //Reset the time of the recorded audio.
        audioPlayer.currentTime = 0
        
        // Disable the stop button.
        stopEffectButton.enabled = false
    }

}
