//
//  UIImageView.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/10/22.
//

import UIKit

extension UIImageView {

    typealias BreakCondition = (_ urlString: String) -> Bool

    func setImage(
        for urlString: String,
        imageCache: ImageChache = .shared,
        breakCondition: BreakCondition? = nil
    ) {
        guard let request = URL(string: urlString) else { return }
        setImage(for: request, imageCache: imageCache, breakCondition: breakCondition)
    }

    func setImage(
        for url: URL,
        imageCache: ImageChache = .shared,
        breakCondition: BreakCondition? = nil
    ) {
        setImage(for: URLRequest(url: url), imageCache: imageCache, breakCondition: breakCondition)
    }

    func setImage(
        for request: URLRequest,
        imageCache: ImageChache = .shared,
        breakCondition: BreakCondition? = nil
    ) {
        if let image = imageCache.image(forKey: request) {
            self.image = image
        } else {
            request.getData { [weak self] data in
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let image = UIImage(data: data) else { return }
                    imageCache.set(image, forKey: request)
                    if breakCondition?(request.url?.absoluteString ?? "") == true { return }
                    self?.image = image
                }
            }
        }
    }
}
