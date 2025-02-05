//
//  ImageCache.swift
//  FetchProject
//
//  Created by Kelvin Reid on 2/4/25.
//

import SwiftUI

// This handles caching images for efficient network usage
// It uses NSCache to store images in memory
class ImageCache {
    private var cache = NSCache<NSURL, UIImage>()
    
    static let shared = ImageCache()
    
    private init() {}
    
    // Asynchronously loads an image from the URL
    func loadImage(from url: URL) async throws -> UIImage? {
        
        // Check if the image is already in the cache
        if let cachedImage = cache.object(forKey: url as NSURL) {
            
            // If the image is in the cache, return it
            return cachedImage
        }
        
        // If the image is not in the cache, download it
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Create a UIImage from the downloaded data
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        // Store the downloaded image in the cache
        cache.setObject(image, forKey: url as NSURL)
        
        // Return the downloaded image
        return image
    }
}
