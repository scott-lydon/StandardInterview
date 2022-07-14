//
//  UIImage.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/13/22.
//

import UIKit

extension UIImage {
    
    /// This doesn't work out because Data gives no indication of the size (height and width) of the image.
    static func create(data: Data, estimatedScale: CGFloat, minDimension: CGFloat) -> UIImage? {
        var result: UIImage?
        var estimatedScale = estimatedScale
        while true {
            guard let image = UIImage(data: data, scale: estimatedScale) else { return nil }
            result = image
            if image.size.width >= minDimension && image.size.height >= minDimension {
                print("image was sufficient width: \(image.size.width), and height: \(image.size.height), minDimension: \(minDimension)")
                return result
            }
            print("Having to reup images.")
            estimatedScale = estimatedScale / 2
            if estimatedScale > 1 {
                return UIImage(data: data)
            }
        }
    }
}
