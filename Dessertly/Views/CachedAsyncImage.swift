//
//  CachedAsyncImage.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/19/24.
//

import SwiftUI

/// A view that asynchronously loads and caches an image from a given URL.
struct CachedAsyncImage: View {
    let url: URL
    
    @State private var image: UIImage?
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            ProgressView()
                .onAppear {
                    loadImage()
                }
        }
    }
    
    /// Loads the image from the cache or fetches it from the network if not cached.
    private func loadImage() {
        if let cachedImage = ImageCache.shared.getImage(forKey: url.absoluteString) {
            self.image = cachedImage
        } else {
            Task {
                await fetchImage()
            }
        }
    }
    
    /// Fetches the image asynchronously using `URLSession` and caches it.
    private func fetchImage() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let loadedImage = UIImage(data: data) {
                ImageCache.shared.setImage(loadedImage, forKey: url.absoluteString)
                
                await MainActor.run {
                    self.image = loadedImage
                }
            }
        } catch {
            print("Failed to load image: \(error.localizedDescription)")
        }
    }
}
