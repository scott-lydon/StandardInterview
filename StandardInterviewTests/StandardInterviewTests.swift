//
//  StandardInterviewTests.swift
//  StandardInterviewTests
//
//  Created by Scott Lydon on 7/10/22.
//

import XCTest
@testable import StandardInterview

final class StandardInterviewTests: XCTestCase {

    func testImageCache() {
        let screenShot = "screenShot"
        let image = UIImage(named: screenShot)!
        ImageChache.shared.set(image, forKey: screenShot)
        let checkedImage = ImageChache.shared.image(forKey: screenShot)
        XCTAssertEqual(image, checkedImage)
        XCTAssertNotEqual(image, .init())
    }

    func testClearImageCache() {
        let screenShot = "screenShot"
        let image = UIImage(named: screenShot)!
        ImageChache.shared.set(image, forKey: screenShot)
        ImageChache.shared.clearCache()
        XCTAssertNil(ImageChache.shared.image(forKey: screenShot))
    }

    func testCacheLimit() {
        let screenShot = "screenShot"
        let second = "secondScreen"
        let image = UIImage(named: screenShot)!
        let secondImage = UIImage(named: second)!
        ImageChache.shared.cacheSize = 1
        ImageChache.shared.set(image, forKey: screenShot)
        ImageChache.shared.set(secondImage, forKey: second)
        XCTAssertNil(ImageChache.shared.image(forKey: screenShot))
        XCTAssertEqual(ImageChache.shared.image(forKey: second), secondImage)
    }
}
