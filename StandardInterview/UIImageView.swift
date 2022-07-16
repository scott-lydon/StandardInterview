//
//  UIImageView.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/10/22.


import UIKit
import PersistenceCall

public extension UIImageView {
    
    /// We get URL created by the system in call
    ///  This makes sure that by the time the dataTask completion is called for the UIIMageView,
    ///  it is still the correct image data that should be applied to this UIImageView.
    /// KEY: is the UIImageView address
    /// Value: is the url which has the corresponding data. 
    private static var imageURLMatchCache: NSCache<NSString, NSString> = .init()
    
    /*
     If the image is available in the image cache, skip,
     if the downloadHashImgDataCache doesn't have the hash, skip
     if the FileHandle(forReadingFrom: localURL) is empty, skip
     then create the downloadTask and return it.
     
     //
     Concern
     Need to check the cache in the set image for download task before getting a new download cache.
     
     
     */
    
    /// <#Description#>
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - placeholderImage: <#placeholderImage description#>
    ///   - backgroundColor: <#backgroundColor description#>
    ///   - dataImageScale: <#dataImageScale description#>
    func setImage(
        url: String,
        indexPath: IndexPath? = nil,
        placeholderImage: UIImage? = nil,
        backgroundColor: UIColor = .gray,
        dataImageScale: CGFloat = 1,
        dimensionMultiplier: CGFloat = 2
        // for some reason the the dimensions for thumbnails seems to be a bit too small
    ) {

        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
        
        Self.imageURLMatchCache[tmpAddress] = url
                    
        if let image = ImageChache.shared.image(forKey: url) ?? placeholderImage {
            self.backgroundColor = nil
            self.image = image
            return
        } else {
            self.backgroundColor = backgroundColor
        }
        
        let downloadTask = url.url?.request?.callPersistDownloadData(fetchStrategy: .alwaysUseCacheIfAvailable) {
            [weak self] data in
            guard let image = UIImage(data: data) else { return }
            
            if Self.imageURLMatchCache[tmpAddress] == url {
                DispatchQueue.main.async {
                    self?.image = image
                    self?.backgroundColor = .clear
                    self?.setNeedsDisplay()
                    self?.setNeedsLayout()
                }
            }
            /// I was tempted to assign the actual image along with the smaller version, but I think if I do that it will clog up RAM.
            /// I think clogging up ram may cause glitchyness
            ImageChache.shared.set(image, forKey: url)
        }
        if let indexPath {
            IndexPathDataTaskCache.shared[indexPath] = downloadTask
        }
    }
}
    
extension NSCache where KeyType == NSString, ObjectType == NSString {
    subscript (_ key: String) -> String? {
        get {
            object(forKey: key as NSString) as? String
        }
        set {
            guard let newValue else { return }
            setObject(newValue as NSString, forKey: key as NSString)
        }
    }
}
