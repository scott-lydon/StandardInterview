//
//  CGRect.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/13/22.
//

import Foundation

extension CGRect {
    var maxDimension: CGFloat {
        [height, width].compactMap {$0 }.max()!
    }
}
