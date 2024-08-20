//
//  ImageCache.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/19/24.
//

import Foundation
import UIKit

/// A singleton class responsible for caching images.
final class ImageCache {
    static let shared = ImageCache()
    
    /// The underlying cache that stores images with `NSString` keys.
    private var cache = NSCache<NSString, UIImage>()
    
    /// Retrieves an image from the cache for a given key.
    /// - Parameter key: The key associated with the image.
    /// - Returns: The cached `UIImage` if found, or `nil` if the image isn't cached.
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    /// Stores an image in the cache with a given key.
    /// - Parameters:
    ///   - image: The `UIImage` to cache.
    ///   - key: The key to associate with the image.
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
