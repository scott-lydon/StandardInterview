//
//  IndexPathDataTaskCache.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/15/22.
//

import Foundation

/// A way to help with prefetching and cancelling
class IndexPathDataTaskCache {
    private init() {}
    public static let shared: IndexPathDataTaskCache = .init()
    
    private var nsCache: NSCache<NSIndexPath, URLSessionDownloadTask> = .init()
    
    subscript (_ indexPath: IndexPath) -> URLSessionDownloadTask? {
        get {
            nsCache.object(forKey: indexPath as NSIndexPath)
        }
        set {
            guard let downloadTask = newValue else { return }
            nsCache.setObject(downloadTask, forKey: indexPath as NSIndexPath)
        }
    }    
}
