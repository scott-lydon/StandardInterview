//
//  UIImageView.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/10/22.
//
//
//import UIKit
//import PersistenceCall
//
//extension UIImageView {
//
//    typealias BreakCondition = (_ urlString: String) -> Bool
////
////    func setImage(
////        for urlString: String,
////        imageCache: ImageChache = .shared,
////        breakCondition: BreakCondition? = nil
////    ) {
////        guard let request = URL(string: urlString) else { return }
////        setImage(for: request, imageCache: imageCache, breakCondition: breakCondition)
////    }
////
////    func setImage(
////        for url: URL,
////        imageCache: ImageChache = .shared,
////        breakCondition: BreakCondition? = nil
////    ) {
////        setImage(for: URLRequest(url: url), imageCache: imageCache, breakCondition: breakCondition)
////    }
//    
//    private static var urlStore = [String: String]()
//    
//    func setImage(
//        url: String,
//        placeholderImage: UIImage? = nil
//    ) {
//        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
//        Self.urlStore[tmpAddress] = url
//        if let image = ImageChache.shared.image(forKey: url) {
//            self.image = image
//            return
//        } else if let image = placeholderImage {
//            self.image = image
//        } else {
//            self.backgroundColor = .gray
//        }
//        url.url?.request?.callPersistData(fetchStrategy: .alwaysUseCacheIfAvailable) {
//            [weak self] data in
//            guard let image = UIImage(data: data) else { return }
//            ImageChache.shared.set(image, forKey: url)
//            DispatchQueue.main.async {
//                if Self.urlStore[tmpAddress] == url {
//                    self?.image = image
//                    self?.backgroundColor = .clear
//                }
//            }
//        }
//    }
//
////    func setImage(
////        for request: URLRequest,
////        imageCache: ImageChache = .shared,
////        breakCondition: BreakCondition? = nil
////    ) {
////        if let image = imageCache.image(forKey: request) {
////            self.image = image
////        } else {
////            request.callPersistData(fetchStrategy: .alwaysUseCacheIfAvailable) { [weak self] data in
////                DispatchQueue.global(qos: .background).async { [weak self] in
////                    guard let image = UIImage(data: data) else { return }
////                    imageCache.set(image, forKey: request)
////                    DispatchQueue.main.async {
////                        if breakCondition?(request.url?.absoluteString ?? "") == true { return }
////                        self?.image = image
////                    }
////                }
////            }
////        }
////    }
//}


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
           //  guard let image = UIImage(data: data) else { return }
            //print("data size: \(data.count), image size: \(image.fileSizeInKB), width: \(image.size.width), height: \(image.size.height)")
            
            /// Based on the size of the data, maybe I can make a heuristic for what the potential width and height may be.  and then I can scale it accordingly.
            /// It seems the data ratio is about 30x or the data.count is greater than 30 x either the width or the height.
            /// This means that if we scale the data image down 30x then we should still have a large enough image for display purposes... In theory.
            ///  So first we get the max of the width and height
            
            // If the data.count = 11262934.0, and the width is 250, and you only need the width to be 10, then you can have the width be 25x smaller, or the whole data to be 25^2 smaller for a total of data.count / 25^2, for  or multiplier 1 / (dataWidthEstimate)^2
            // lets say width is only 30x smaller.
            // 1 / (data.count / 30) ^ 2
            
            // Assign the smaller adjusted image.
            
            
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
    
