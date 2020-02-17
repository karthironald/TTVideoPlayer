//
//  ExploreViewController.swift
//  VideoPlayer
//
//  Created by Karthick Selvaraj on 15/02/20.
//  Copyright © 2020 Demo. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

    // Show status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataManager.shared.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoryTableViewCell.self)) as? CategoryTableViewCell else { return UITableViewCell() }
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let category = DataManager.shared.categories?[section] else { return nil }
        #warning("Need to move contant values to constants file")
        let customview = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
        customview.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 15, y: 16, width: tableView.bounds.width, height: 24))
        label.text = category.title
        label.font = UIFont.boldSystemFont(ofSize: 18)
        customview.addSubview(label)
        return customview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000000001 // We are getting space between sections, to avoid it we are giving this negligible height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235.0
    }
    
}


extension ExploreViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.categories?[collectionView.tag].nodes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VideoThumbnailCollectionViewCell.self), for: indexPath) as? VideoThumbnailCollectionViewCell else { return UICollectionViewCell() }
        if let category = DataManager.shared.categories?[collectionView.tag] {
            cell.updateCell(with: category.nodes?[indexPath.row].video)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 205)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let videoPlayerViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: VideoPlayerViewController.self)) as? VideoPlayerViewController {
            videoPlayerViewController.category = DataManager.shared.categories?[collectionView.tag]
            videoPlayerViewController.indexPath = indexPath
            navigationController?.pushViewController(videoPlayerViewController, animated: true)
        }
    }
    
}
