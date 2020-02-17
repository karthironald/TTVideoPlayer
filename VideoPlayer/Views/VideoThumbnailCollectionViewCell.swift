//
//  VideoThumbnailCollectionViewCell.swift
//  VideoPlayer
//
//  Created by Karthick Selvaraj on 15/02/20.
//  Copyright © 2020 Demo. All rights reserved.
//

import UIKit
import AVKit

class VideoThumbnailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    private var assetImageGenerator: AVAssetImageGenerator?
    private var requestedUrlPath: String?
    
    
    // MARK: - Initialiser methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customise()
    }
    
    
    // MARK: - Custom methods
    
    /**Customise cell*/
    private func customise() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    /**Updates cell with video details*/
    func updateCell(with video: Video?) {
        resetDetails()
        activityIndicator.startAnimating()
        createThumbnailImage(from: video?.encodeUrl)
    }
    
    /**Shows default thumbnail image for the video*/
    private func defaultThumbnailImage() {
        thumbnailImageView.image = UIImage(named: "Placeholder")
        activityIndicator.stopAnimating()
    }
    
    /**Resets local details*/
    private func resetDetails() {
        assetImageGenerator = nil
        requestedUrlPath = nil
        thumbnailImageView.image = nil
    }
    
    /**Created thumbnail from server video path and updates it in image view*/
    private func createThumbnailImage(from remotePath: String?) {
        if remotePath == requestedUrlPath { return } // Return if request is already made
        if let path = remotePath, let url = URL(string: path) {
            if let image = DataManager.shared.cachedImage(for: path) { // Load image from cache
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.thumbnailImageView.image = image
                }
            } else { // Generate thumbnail from server as it is not available in cache
                assetImageGenerator?.cancelAllCGImageGeneration() // Cancel already request thumbnail generation
                let asset = AVAsset(url: url)
                assetImageGenerator = AVAssetImageGenerator(asset: asset)
                assetImageGenerator?.appliesPreferredTrackTransform = true
                let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
                let value = NSValue(time: time)
                requestedUrlPath = path
                // Generate thumbnail image asyncly.
                #warning("Need to handle internet office scenario")
                assetImageGenerator?.generateCGImagesAsynchronously(forTimes: [value], completionHandler: { (_, image, _, result, error) in
                    if let image = image, result == .succeeded, error == nil {
                        let thumbNail = UIImage(cgImage: image)
                        DataManager.shared.cache(image: thumbNail, path: path)
                        DispatchQueue.main.async {
                            self.resetDetails()
                            self.activityIndicator.stopAnimating()
                            self.thumbnailImageView.image = thumbNail
                        }
                    } else {
                        if result != .cancelled {
                            DispatchQueue.main.async {
                                self.resetDetails()
                                self.defaultThumbnailImage()
                            }
                        }
                    }
                })
            }
        } else {
            DispatchQueue.main.async {
                self.defaultThumbnailImage()
            }
        }
    }
    
}
