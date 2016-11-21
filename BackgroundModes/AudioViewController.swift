//
//  AudioViewController.swift
//  BackgroundModes
//
//  Created by Fun Life on 11/16/16.
//  Copyright © 2016 FunLife. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {

    @IBOutlet var songLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    lazy var player: AVQueuePlayer = self.makePlayer()
    
    private lazy var songs: [AVPlayerItem] = {
        let songNames = ["FeelinGood", "IronBacon", "WhatYouWant"]
        return songNames.map {
            let url = Bundle.main.url(forResource: $0, withExtension: "mp3")!
            return AVPlayerItem(url: url)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSessionCategoryPlayAndRecord,
                with: .defaultToSpeaker)
        } catch {
            print("Failed to set audio session category.  Error: \(error)")
        }
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 100), queue: DispatchQueue.main) {
            [weak self] time in
            guard let strongSelf = self else { return }
            let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
            
            if UIApplication.shared.applicationState == .active {
                strongSelf.timeLabel.text = timeString
            } else {
                print("Background: \(timeString)")
            }
        }
    }
    
    private func makePlayer() -> AVQueuePlayer {
        let player = AVQueuePlayer(items: songs)
        player.actionAtItemEnd = .advance
        player.addObserver(self, forKeyPath: "currentItem", options: [.new, .initial] , context: nil)
        return player
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem", let player = object as? AVPlayer,
            let currentItem = player.currentItem?.asset as? AVURLAsset {
            songLabel.text = currentItem.url.lastPathComponent
        }
    }
    
    @IBAction func btnPlay(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            player.play()
        } else {
            player.pause()
        }

    }

}

