//
//  ImageCache.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/10/22.

import UIKit

/// A wrapper to enforce one instance of a thread safe image cache.
public class ImageChache {
    private init() {}
    static public let shared: ImageChache = .init()
    private var nsCache: NSCache<NSURLRequest, UIImage> = .init()
    public var cacheSize: Int = 100 {
        didSet {
            nsCache.countLimit = cacheSize
        }
    }
    
    func cancel(for url: String) {
        
    }
    
    func prefetch(for url: String) {
        guard image(forKey: url) == nil else { return }
        
        
    }
    
//    public func image(for url: String, maxDimension: CGFloat) -> UIImage? {
//        image(forKey: url + String(maxDimension)) ??
//        image(forKey: url)?.resizeImageProportionately(maxSize: CGSize(width: maxDimension, height: maxDimension))
//    }

    public func image(forKey key: String) -> UIImage? {
        guard let url = URL(string: key) else { return nil }
        return image(forKey: url)
     }

     public func set(_ image: UIImage, forKey key: String) {
         guard let url = URL(string: key) else { return }
         set(image, forKey: url)
     }

    public func image(forKey key: URL) -> UIImage? {
        image(forKey: URLRequest(url: key))
     }

     public func set(_ image: UIImage, forKey key: URL) {
         set(image, forKey: URLRequest(url: key))
     }

    public func image(forKey key: URLRequest) -> UIImage? {
         nsCache.object(forKey: key as NSURLRequest)
     }

     public func set(_ image: UIImage, forKey key: URLRequest) {
         nsCache.setObject(image, forKey: key as NSURLRequest)
     }

    public func clearCache() {
        // Let ARC manage clearing the cache.
        self.nsCache = .init()
    }
}
