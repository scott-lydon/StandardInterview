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
    private static var urlStore: NSCache<NSString, NSString> = .init()
    
    
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
        dimensionMultiplier: CGFloat = 2 // for some reason the the dimensions for thumbnails seems to be a bit too small
    ) {
        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
        Self.urlStore.setObject(url as NSString, forKey: tmpAddress as NSString)
        let maxDimension = frame.maxDimension * dimensionMultiplier
                    
        if let image = ImageChache.shared.image(for: url, maxDimension: maxDimension) {
            self.image = image
            self.backgroundColor = nil
            return
        } else if let image = placeholderImage {
            self.backgroundColor = nil
            self.image = image
        } else {
            self.backgroundColor = backgroundColor
        }
        
        url.url?.request?.callPersistDownloadData(fetchStrategy: .alwaysUseCacheIfAvailable) {
            // .callPersistData(fetchStrategy: .alwaysUseCacheIfAvailable) {
            [weak self] data in
            // let scale: CGFloat =
            guard let image: UIImage = UIImage(data: data)?
                .resizeImageProportionately(
                    maxSize: CGSize(width: maxDimension, height: maxDimension)
                )
            else { return }
            
            DispatchQueue.main.async {
                if Self.urlStore.object(forKey: tmpAddress as NSString) == url as NSString {
                    self?.image = image
                    self?.backgroundColor = .clear
                    self?.setNeedsDisplay()
                    self?.setNeedsLayout()
                }
            }
            /// I was tempted to assign the actual image along with the smaller version, but I think if I do that it will clog up RAM.
            /// I think clogging up ram may cause glitchyness
            ImageChache.shared.set(image, forKey: url + String(maxDimension))
        }
    }
}
    
