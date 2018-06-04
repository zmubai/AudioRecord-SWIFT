//
//  ViewController.swift
//  SimpleRecoder
//
//  Created by zengbailiang on 2018/5/20.
//  Copyright © 2018年 zengbailiang. All rights reserved.
//

import UIKit
import AVFoundation
import Mp3CodeKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordInit()
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBAction func recordAction(_ sender: Any) {
        self.startRecord()
        statusLabel.text = "----"
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
//            self.transformToMp3();
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        self.playLocalRecord()
    }
    
    @IBAction func stopRecord(_ sender: Any) {
        self.audioRecorder?.stop();
    }
    
    
    @IBAction func transformToMp3Action(_ sender: Any) {
        let mp3coder:MP3Coder = MP3Coder.init();
        let status = mp3coder.codeTomp3(srcFile: self.path(), dstFile: self.mp3path())
        
        if status == 1 {
            statusLabel.text = "转码完成！"
        }
        else
        {
            statusLabel.text = "转码失败"
        }
        
    }
    
    @IBAction func playMp3(_ sender: Any) {
        self.playMp3();
    }
    
    
    func mp3path()->String
    {
        let docPath :String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let path = docPath + "/record.mp3"
       
        return path
    }
    
    func playMp3()
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("error:\(error.domain)")
        }
        self.mp3Player?.numberOfLoops = 0
        self.mp3Player?.play()
        
    }
    
    func path() -> String
    {
        let docPath :String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let path = docPath + "/record.pcm"
        
        return path
    }
    
    func recordInit()
    {
        //SETUP 1
        let audioSession = AVAudioSession.sharedInstance();
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
        } catch let error as NSError {
            print("ERROR:\(error.domain)")
        }
    }
    
    func startRecord() {
        self.audioRecorder?.record();
    }
    
    func playLocalRecord()
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("error:\(error.domain)")
        }
        self.audioPlay?.numberOfLoops = 0
        self.audioPlay?.play()
    }
    
    lazy var audioPlay:AVAudioPlayer? = {
        var tempAudioPlay : AVAudioPlayer?
        do {
            try tempAudioPlay = AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: self.path()))
        } catch let error as NSError {
            print("error:\(error.domain)")
        }
        tempAudioPlay?.delegate = self
        return tempAudioPlay;
    }()
    
    lazy var mp3Player:AVAudioPlayer? = {
        var tempAudioPlay : AVAudioPlayer?
        do {
            try tempAudioPlay = AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: self.mp3path()))
        } catch let error as NSError {
            print("error:\(error.domain)")
        }
        tempAudioPlay?.delegate = self
        return tempAudioPlay;
    }()
    
    lazy var audioRecorder :AVAudioRecorder? = {
        //SETUP 2
        let recorderSettings = [AVSampleRateKey : NSNumber.init(value: 44100.0),//采样频率
                                AVFormatIDKey : NSNumber.init(value: kAudioFormatLinearPCM),//录制格式
                                AVNumberOfChannelsKey : NSNumber.init(value: 2),//频道数量
                                AVEncoderAudioQualityKey : NSNumber.init(value: AVAudioQuality.medium.rawValue)]//录制质量
        
        var tempRecorder:AVAudioRecorder?
        do {
            try tempRecorder = AVAudioRecorder.init(url: URL.init(fileURLWithPath: self.path()), settings:
                recorderSettings)
        } catch let error as NSError {
            print("ERROR:\(error.domain)")
        }
        tempRecorder?.delegate = self as AVAudioRecorderDelegate
        tempRecorder?.isMeteringEnabled = true 
        return tempRecorder
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: "Recorder",
                                              message: "Finished Recording",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK!", style: .default, handler: {action in
                    print("OK was tapped")
                }))
                self.present(alert, animated:true, completion:nil)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension ViewController:AVAudioPlayerDelegate{
    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{ print("播放完成!") }
    }
}


