//
//  HomeViewController.swift
//  Liaison
//
//  Created by gabriel troia on 3/26/17.
//  Copyright © 2017 gabriel troia. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recordButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    
    var audioURL: URL!
    
    var records = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        loadSampleRecords()
        
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        recordButton.addTarget(self, action: #selector(toggleRecord),for: .touchDown)
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission({ [unowned self] allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        self.loadFailUI()
                    }
                }
                
            })
        } catch {
            loadFailUI()
        }
    }
    
    func loadFailUI() {
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
        
        recordButton.setTitle("Release", for: .normal)
        recordButton.addTarget(self, action: #selector(toggleRecord), for: .touchUpInside)
        
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
        recorder.stop()
        recorder = nil
        
        if success {
            print("Recording finished successfully")
            
            saveNewRecord()
            recordButton.setTitle("Hold", for: .normal)
            
        } else {
            print("Recording failed")
        }
    }
    
    func saveNewRecord() {
        guard let newRecord = Record(title: "new word \(records.count)", audioURL: audioURL) else {
            fatalError("Unable to instantiate record")
        }
        
        records += [newRecord];
        tableView.reloadData()
        
        print("record \(newRecord.title) saved")
        
        
    }
    
    func getRecordingUrl() -> URL {
        let timestamp = Int64(NSDate().timeIntervalSince1970 * 1000)
        return ViewController.getDocumentsDirectory().appendingPathComponent("recording-\(String(timestamp)).m4a")
    }
    
    class func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as? RecordTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecordTableViewCell.");
        }
        
        let record = records[indexPath.row]
        
        cell.wordNameLabel.text = record.title
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        let currentRecord = records[indexPath.row]
        
        startPlayer(audioURL: currentRecord.audioURL)
    }
    
    func startPlayer(audioURL: URL) {
        print("start player \(audioURL.absoluteURL)")
        do {
            
            //playButton.setTitle("Stop", for: .normal)
            
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
        
        //playButton.setTitle("Play", for: .normal)
    }
    
    private func loadSampleRecords() {
        guard let record1 = Record(title: "cat", audioURL: URL(string: "cat.m4a")!) else {
            fatalError("Unable to instantiate record")
        }
        
        guard let record2 = Record(title: "dog", audioURL: URL(string: "cat.m4a")!) else {
            fatalError("Unable to instantiate record")
        }
        
        guard let record3 = Record(title: "bird", audioURL: URL(string: "cat.m4a")!) else {
            fatalError("Unable to instantiate record")
        }
        
        records += [record1, record2, record3]
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
