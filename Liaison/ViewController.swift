//
//  ViewController.swift
//  Liaison
//
//  Created by gabriel troia on 3/18/17.
//  Copyright © 2017 gabriel troia. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var wordLabel: UILabel!
    
    
    //MARK: AV Properties
    
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var stackView: UIStackView!
    
    var audioURL: URL!
    
    var playButton: UIButton!
    var player: AVAudioPlayer!
    
    override func loadView() {
        super.loadView()
        
        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackViewDistribution.fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        wordTextField.delegate = self
        
        view.backgroundColor = UIColor.darkGray
        
    
        // Audio
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
        
            recordingSession.requestRecordPermission({ [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.loadFailUI()
                    }
                }
                
            })
        } catch {
            loadFailUI()
        }
    }
    
    func loadRecordingUI() {
        print("load recording ui")
        
        recordButton = UIButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setTitle("Record", for: .normal)
        recordButton.addTarget(self, action: #selector(toggleRecord),for: .touchUpInside )
        
        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
        
        stackView.addArrangedSubview(recordButton)
        stackView.addArrangedSubview(playButton)
        
    }
    
    func loadFailUI() {
        
    }
    
    
    func togglePlay() {
        if player == nil {
            startPlayer(audioURL: audioURL)
        } else {
            stopPlayer()
        }
    }
    
    func startPlayer(audioURL: URL) {
        print("start player \(audioURL.absoluteURL)")
        do {
            
            playButton.setTitle("Stop", for: .normal)
            
            player = try AVAudioPlayer(contentsOf: audioURL)
            player.delegate = self
            
            player!.prepareToPlay()
            player!.play()
        } catch {
            print (error.localizedDescription)
        }
    }
    
    func stopPlayer() {
        player!.stop()
        player = nil
        
        playButton.setTitle("Play", for: .normal)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
        stopPlayer()
    }
    
    func toggleRecord() {
        if recorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func startRecording() {
        print("recording")
        
        view.backgroundColor = UIColor.red
        
        recordButton.setTitle("Tap to stop", for: .normal)
        
        audioURL = getRecordingUrl();
        print(audioURL.absoluteURL)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioURL, settings: settings)
            recorder.delegate = self
            recorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        view.backgroundColor = UIColor.darkGray
        
        recorder.stop()
        recorder = nil
        
        if success {
            print("Recording finished successfully")
        
            recordButton.setTitle("Record", for: .normal)
        
        } else {
            print("Recording failed")
        }
    }

    func getRecordingUrl() -> URL {
        let timestamp = Int64(NSDate().timeIntervalSince1970 * 1000)
        return ViewController.getDocumentsDirectory().appendingPathComponent("recording-\(String(timestamp)).m4a")
    }
    
    class func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    //MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        wordLabel.text = "Reset value"
        wordTextField.placeholder = "hmm"
    }
    
    //MARK: Text Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        wordLabel.text = textField.text
    }

}

