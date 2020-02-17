//
//  DataManager.swift
//  VideoPlayer
//
//  Created by Karthick Selvaraj on 15/02/20.
//  Copyright © 2020 Demo. All rights reserved.
//

import Foundation
import UIKit

class DataManager {

    static let shared = DataManager()
    var categories: [Category]?
    var cache = NSCache<NSString, UIImage>()
    
    // Private initialiser
    private init() { }
    
    
    // MARK: - Custom methods
    
    /**Load JSON data from file and decode it*/
    func parse() {
        if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                categories = try JSONDecoder().decode([Category].self, from: jsonData)
            } catch {
                print("❌ Couldn't parse data")
            }
        }
    }
    
    /**Caches given image with path as key*/
    func cache(image: UIImage?, path: String?) {
        if let image = image, let path = path {
            cache.setObject(image, forKey: path as NSString)
        }
    }
    
    /**Get cached image for given path(key)*/
    func cachedImage(for path: String?) -> UIImage? {
        guard let path = path else { return nil }
        return cache.object(forKey: path as NSString)
    }
    
}

class Category: Decodable {
    var title: String?
    var nodes: [Nodes]?
}

class Video: Decodable {
    var encodeUrl: String?
}

class Nodes: Decodable {
    var video: Video?
}
