//
//  UIImageView.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/10/22.


import UIKit
import PersistenceCall

public extension UIImageView {
    
    /// We get URL created by the system in call
    /// KEY: is the UIImageView address
    /// Value: is the url which has the corresponding data. 
    private static var imageURLMatchCache: NSCache<NSString, NSString> = .init()
    
    
 
    
    /// <#Description#>
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - placeholderImage: <#placeholderImage description#>
    ///   - backgroundColor: <#backgroundColor description#>
    ///   - dataImageScale: <#dataImageScale description#>
    func setImage(
        url: String,
        placeholderImage: UIImage? = nil,
        backgroundColor: UIColor = .gray,
        dataImageScale: CGFloat = 1,
        dimensionMultiplier: CGFloat = 2
        // for some reason the the dimensions for thumbnails seems to be a bit too small
    ) {

        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
        let maxDimension = frame.maxDimension * dimensionMultiplier
        
        Self.imageURLMatchCache.setObject(url as NSString, forKey: tmpAddress as NSString)
                    
        if let image = ImageChache.shared.image(for: url, maxDimension: maxDimension) ?? placeholderImage {
            self.backgroundColor = nil
            self.image = image
            return
        } else {
            self.backgroundColor = backgroundColor
        }
        
        let dataAction: DataAction = { [weak self] data in
            // Resizing the image makes a substantial improvement
            // against choppiness, leads to smoother scrolling.
            guard let image: UIImage = UIImage(data: data)?.resize(maxDimension: maxDimension) else {
                return
            }
            if Self.imageURLMatchCache.object(forKey: tmpAddress as NSString) == url as NSString {
                DispatchQueue.main.async {
                    self?.image = image
                    self?.backgroundColor = .clear
                    self?.setNeedsDisplay()
                    self?.setNeedsLayout()
                }
            }
            // I was tempted to assign the actual image along with the smaller version
            // but I think if I do that it will clog up RAM.
            // I think clogging up ram may cause glitchyness
            ImageChache.shared.set(image, forKey: url + String(maxDimension))
        }
        if let interceptor = urlDownloadTaskCache.object(forKey: url as NSString) {
            interceptor.dataAction = dataAction
            return
        }
        let interceptor: DownloadTaskInterceptor = .init()
        interceptor.dataAction = dataAction
        interceptor.downloadTask = url.url?.request?.callPersistDownloadData(fetchStrategy: .alwaysUseCacheIfAvailable) { data in
            interceptor.dataAction?(data)
        }
        interceptor.downloadTask?.resume()
        urlDownloadTaskCache.setObject(interceptor, forKey: url as NSString)
    }
}

//extension ImageChache {
//    
//    func prefetch(url: String, maxDimension: CGFloat) {
//        
//    }
//}


typealias DataAction = (Data) -> Void

class DownloadTaskInterceptor {
    var dataAction: DataAction?
    var downloadTask: URLSessionDownloadTask?
}

var urlDownloadTaskCache: NSCache<NSString, DownloadTaskInterceptor> = .init()

/*
 
 */
