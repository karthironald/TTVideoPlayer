//
//  VideoPlayerViewController.swift
//  VideoPlayer
//
//  Created by Karthick Selvaraj on 15/02/20.
//  Copyright © 2020 Demo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "VideoPlayerCollectionViewCell"

class VideoPlayerViewController: UIViewController {
    
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    var category: Category?
    var indexPath: IndexPath?
    @IBOutlet weak private var collectionView: UICollectionView!
    
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToIndexPath()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - Action methods
    
    @IBAction private func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Custom methods
    
    /**Scrolls to user selected indexpath*/
    private func scrollToIndexPath() {
        guard let ip = indexPath else { return }
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: ip, at: .top, animated: false)
        }
    }
    
}


extension VideoPlayerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category?.nodes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? VideoPlayerCollectionViewCell else { return UICollectionViewCell() }
        let video = category?.nodes?[indexPath.row].video
        cell.updatedCell(with: video)
        if let selectedIndexPath = self.indexPath, indexPath.row == selectedIndexPath.row {
            cell.isPlaying = true
        } else {
            cell.isPlaying = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoPlayerCollectionViewCell {
            cell.isPlaying = !cell.isPlaying
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = collectionView.contentOffset.y / collectionView.frame.height // Get current visible collectionView cell
        if index.truncatingRemainder(dividingBy: 1) == 0.0 { // Check whether acrolling is stopped completely
            if let previousIp = self.indexPath {
                // Stop video in previous cell
                let previousCell = collectionView.cellForItem(at: previousIp) as? VideoPlayerCollectionViewCell
                previousCell?.isPlaying = false
                
                // Start playing video in current visible cell
                let newIndexPath = IndexPath(row: Int(index), section: 0)
                let currentCell = collectionView.cellForItem(at: newIndexPath) as? VideoPlayerCollectionViewCell
                currentCell?.playFromBegining() // Set to play from starting
                currentCell?.isPlaying = true
                
                self.indexPath = newIndexPath
            }
        }   
    }
    
}
