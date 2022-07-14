//
//  StandardInterviewTests.swift
//  StandardInterviewTests
//
//  Created by Scott Lydon on 7/10/22.
//

import XCTest
@testable import StandardInterview

final class StandardInterviewTests: XCTestCase {
//
//    func testImageCache() {
//        let screenShot = "screenShot"
//        let image = UIImage(named: screenShot)!
//        ImageChache.shared.set(image, forKey: screenShot)
//        let checkedImage = ImageChache.shared.image(forKey: screenShot)
//        XCTAssertEqual(image, checkedImage)
//        XCTAssertNotEqual(image, .init())
//    }
//
//    func testClearImageCache() {
//        let screenShot = "screenShot"
//        let image = UIImage(named: screenShot)!
//        ImageChache.shared.set(image, forKey: screenShot)
//        ImageChache.shared.clearCache()
//        XCTAssertNil(ImageChache.shared.image(forKey: screenShot))
//    }
//
//    func testCacheLimit() {
//        let screenShot = "screenShot"
//        let second = "secondScreen"
//        let image = UIImage(named: screenShot)!
//        let secondImage = UIImage(named: second)!
//        ImageChache.shared.cacheSize = 1
//        ImageChache.shared.set(image, forKey: screenShot)
//        ImageChache.shared.set(secondImage, forKey: second)
//        XCTAssertNil(ImageChache.shared.image(forKey: screenShot))
//        XCTAssertEqual(ImageChache.shared.image(forKey: second), secondImage)
//    }
    
    func testResizeImageProportionately() {
        let screen: UIImage? = UIImage(named: "screenShot")
        XCTAssertEqual(screen?.size, .init(width: 462, height: 110))
        let resized: UIImage? = screen?.resizeExact(targetSize: .init(width: 100, height: 100))
        XCTAssertEqual(resized?.size, .init(width: 100, height: 100))
        let proportionately: UIImage? = resized?.resizeImageProportionately(maxSize: .init(width: 10, height: 10))
        XCTAssertEqual(proportionately?.size, .init(width: 10, height: 10))
    }
    
    func testResized10() {
        let screen: UIImage? = UIImage(named: "screenShot")
        XCTAssertEqual(screen?.size, .init(width: 462, height: 110))
        let resized: UIImage? = screen?.resizeExact(targetSize: .init(width: 100, height: 100))
        XCTAssertEqual(resized?.size, .init(width: 100, height: 100))
        let proportionately: UIImage? = resized?.resizeImageProportionately(maxSize: .init(width: 20, height: 10))
        XCTAssertEqual(proportionately?.size, .init(width: 10, height: 10))
    }
    
    func testResized5() {
        let screen: UIImage? = UIImage(named: "screenShot")
        XCTAssertEqual(screen?.size, .init(width: 462, height: 110))
        let resized: UIImage? = screen?.resizeExact(targetSize: .init(width: 100, height: 100))
        XCTAssertEqual(resized?.size, .init(width: 100, height: 100))
        let proportionately: UIImage? = resized?.resizeImageProportionately(maxSize: .init(width: 5, height: 10))
        XCTAssertEqual(proportionately?.size, .init(width: 5, height: 5))
    }
    
    func testFileSize() {
        let screen: UIImage? = UIImage(named: "screenShot")
        XCTAssertEqual(screen?.fileSizeInKB, 15.927)
        let resized: UIImage? = screen?.resizeExact(targetSize: .init(width: 100, height: 100))
        XCTAssertEqual(resized?.size, .init(width: 100, height: 100))
        XCTAssertEqual(resized?.fileSizeInKB, 9.707)
    }
    
    func testScaleImage() {
        let image = UIImage(named: "screenShot")!
        let imgData = image.pngData()!
        // scale does not change the file size in kb!!!!! or it does, but unexpectedly!!!
        XCTAssertLessThan(
            UIImage(data: imgData)!.fileSizeInKB!,
            UIImage(data: imgData, scale: 0.5)!.fileSizeInKB!
        )
        /// The lower the scale, the bigger the image!
        XCTAssertLessThan(
            UIImage(data: imgData)!.size.width,
            UIImage(data: imgData, scale: 0.5)!.size.width
        )
        /// The bigger the scale, the smaller the image dimensions!
        XCTAssertGreaterThan(
            UIImage(data: imgData)!.size.width,
            UIImage(data: imgData, scale: 2)!.size.width
        )
        
        XCTAssertEqual(UIImage(data: imgData)!.size.width, 462)
        
        XCTAssertEqual(UIImage(data: imgData, scale: 2)!.size.width, 231)
        /// The bigger the scale, the smaller the image!
        /// Regardless of whether the scale is increased or decreased, the file size increases slightly but is about equal.
        XCTAssertLessThan(
            UIImage(data: imgData)!.fileSizeInKB!,
            UIImage(data: imgData, scale: 2)!.fileSizeInKB!
        )
        
        let startTime1 = Date()
        let _ = UIImage(data: imgData, scale: 1)
        let endTime1 = Date()
        
        let startTime2 = Date()
        let _ = UIImage(data: imgData, scale: 2)
        let endTime2 = Date()
        
        /// When we raised the scale and decreased the size of the image from the data, the operation was faster!
        XCTAssertGreaterThan(
            (endTime1.timeIntervalSince1970 - startTime1.timeIntervalSince1970) * 10_000,
            (endTime2.timeIntervalSince1970 - startTime2.timeIntervalSince1970) * 10_000
        )
    }
//    
//    func testDataEstimationCalculation() {
//        // take the Data.count from a square image, and the minimum width, return the scale -> scale so that if you create an image with the data and the scale, the width of the image equals the minimum width.
//        let minimumWidth: CGFloat = 10
//        let squareImage = UIImage(named: "colorBox")!
//            .resizeExact(targetSize: .init(width: 680, height: 680))
//        XCTAssertEqual(squareImage!.size, .init(width: 680, height: 680))
//        let imgData =  squareImage!.pngData()!
//        let estimatedScale = estimatedScale(imgData.count, minWidth: 10)
//        XCTAssertEqual(UIImage(data: imgData, scale: estimatedScale)?.size.width, 10)
//        
//    }
//    
//    /// Diffficult because data doesn't necessarily correlate to the size of the image...Perhaps I should check if the data to area ratio is consistent. 
//    func estimatedScale(_ dataCount: Int, minWidth: CGFloat) -> CGFloat {
//        0
//    }
}
