//
//  VideoPlayerCollectionViewCell.swift
//  VideoPlayer
//
//  Created by Karthick Selvaraj on 15/02/20.
//  Copyright © 2020 Demo. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerCollectionViewCell: UICollectionViewCell {
    
    private var asset: AVAsset?
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerLayer: AVPlayerLayer?
    var isPlaying: Bool = false {
        didSet {
            if isPlaying == true {
                playVideo()
            } else {
                pauseVideo()
            }
        }
    }
    var video: Video?
    
    @IBOutlet weak private var playerView: UIView!
    
    
    // MARK: - Initialiser methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustPlayerFrame()
    }
    
    
    // MARK: - Custom methods
    
    /**Updates cell with selected video*/
    func updatedCell(with video: Video?) {
        self.video = video
        
        // Reset old values
        asset = nil
        playerItem = nil
        player = nil
        playerLayer = nil
        
        // Initialise and play video
        #warning("TODO: Set thumnail image until video starts playing")
        #warning("TODO: Need to handle internet offline case")
        if let path = video?.encodeUrl, let url = URL(string: path) {
            asset = AVAsset(url: url)
            playerItem = AVPlayerItem(asset: asset!)
            player = AVPlayer(playerItem: playerItem!)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspect
            adjustPlayerFrame()
            playerView.layer.addSublayer(playerLayer!)
        }
    }
    
    /**Sets player layer frame*/
    private func adjustPlayerFrame() {
        playerLayer?.frame = layer.bounds
    }
    
    /**Plays video*/
    private func playVideo() {
        player?.play()
    }
    
    /**Pauses video*/
    private func pauseVideo() {
        player?.pause()
    }
    
    /**Sets video time to starting of the video */
    func playFromBegining() {
        player?.seek(to: .zero)
    }
    
}
