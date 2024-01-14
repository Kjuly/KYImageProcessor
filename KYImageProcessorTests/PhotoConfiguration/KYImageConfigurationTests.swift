//
//  KYImageConfigurationTests.swift
//  KYImageProcessorTests
//
//  Created by Kjuly on 15/6/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYImageProcessor

final class KYImageConfigurationTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  // MARK: - Image Resolution

  func testKYImageResolution() throws {
    XCTAssertEqual(KYImageResolution.original.rawValue, 0)
    XCTAssertEqual(KYImageResolution.high.rawValue, 1)
    XCTAssertEqual(KYImageResolution.medium.rawValue, 2)
    XCTAssertEqual(KYImageResolution.low.rawValue, 3)
  }

  // MARK: - Image Scale Mode

  func testKYImageScaleMode() throws {
    XCTAssertEqual(KYImageScaleMode.scaleAspectFill.rawValue, 0)
    XCTAssertEqual(KYImageScaleMode.scaleAspectFit.rawValue, 1)
  }

  // MARK: - Image Ratio

  func testKYImageRatioIdentifier() throws {
    XCTAssertEqual(KYImageRatioIdentifier.undefined.rawValue, -1)
    XCTAssertEqual(KYImageRatioIdentifier.none.rawValue, 0)
    // Square
    XCTAssertEqual(KYImageRatioIdentifier.square.rawValue, 1001)
    // Landscape
    XCTAssertEqual(KYImageRatioIdentifier.landscape_5_4.rawValue, 5004)
    XCTAssertEqual(KYImageRatioIdentifier.landscape_4_3.rawValue, 4003)
    XCTAssertEqual(KYImageRatioIdentifier.landscape_7_5.rawValue, 7005)
    XCTAssertEqual(KYImageRatioIdentifier.landscape_3_2.rawValue, 3002)
    XCTAssertEqual(KYImageRatioIdentifier.landscape_5_3.rawValue, 5003)
    XCTAssertEqual(KYImageRatioIdentifier.landscape_16_9.rawValue, 16009)
    // Portrait
    XCTAssertEqual(KYImageRatioIdentifier.portrait_4_5.rawValue, 4005)
    XCTAssertEqual(KYImageRatioIdentifier.portrait_3_4.rawValue, 3004)
    XCTAssertEqual(KYImageRatioIdentifier.portrait_5_7.rawValue, 5007)
    XCTAssertEqual(KYImageRatioIdentifier.portrait_2_3.rawValue, 2003)
    XCTAssertEqual(KYImageRatioIdentifier.portrait_3_5.rawValue, 3005)
    XCTAssertEqual(KYImageRatioIdentifier.portrait_9_16.rawValue, 9016)
  }

  //
  // KYImageRatioIdentifier.getter:textKey
  //
  func testKYImageRatioIdentifierTextKey() throws {
    XCTAssertEqual(KYImageRatioIdentifier.undefined.textKey, "KYLS:Image Ratio:Undefined")
    XCTAssertEqual(KYImageRatioIdentifier.none.textKey, "KYLS:Image Ratio:Fullscreen")
    // Square
    XCTAssertEqual(KYImageRatioIdentifier.square.textKey, "KYLS:Image Ratio:Square")
    // Landscape
    XCTAssertEqual(KYImageRatioIdentifier.landscape_5_4.textKey, "KYLS:Image Ratio:5_4")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_4_3.textKey, "KYLS:Image Ratio:4_3")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_7_5.textKey, "KYLS:Image Ratio:7_5")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_3_2.textKey, "KYLS:Image Ratio:3_2")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_5_3.textKey, "KYLS:Image Ratio:5_3")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_16_9.textKey, "KYLS:Image Ratio:16_9")
    // Portrait
    XCTAssertEqual(KYImageRatioIdentifier.portrait_4_5.textKey, "KYLS:Image Ratio:Portrait:4_5")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_3_4.textKey, "KYLS:Image Ratio:Portrait:3_4")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_5_7.textKey, "KYLS:Image Ratio:Portrait:5_7")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_2_3.textKey, "KYLS:Image Ratio:Portrait:2_3")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_3_5.textKey, "KYLS:Image Ratio:Portrait:3_5")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_9_16.textKey, "KYLS:Image Ratio:Portrait:9_16")
  }

  //
  // KYImageRatioIdentifier.getter:text
  //
  func testKYImageRatioIdentifierText() throws {
    XCTAssertEqual(KYImageRatioIdentifier.undefined.text, "Undefined")
    XCTAssertEqual(KYImageRatioIdentifier.none.text, "Fullscreen")
    // Square
    XCTAssertEqual(KYImageRatioIdentifier.square.text, "Square")
    // Landscape
    XCTAssertEqual(KYImageRatioIdentifier.landscape_5_4.text, "5 : 4")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_4_3.text, "4 : 3")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_7_5.text, "7 : 5")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_3_2.text, "3 : 2")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_5_3.text, "5 : 3")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_16_9.text, "16 : 9")
    // Portrait
    XCTAssertEqual(KYImageRatioIdentifier.portrait_4_5.text, "4 : 5")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_3_4.text, "3 : 4")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_5_7.text, "5 : 7")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_2_3.text, "2 : 3")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_3_5.text, "3 : 5")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_9_16.text, "9 : 16")
  }

  //
  // KYImageRatioIdentifier.text(forCropping:)
  //
  func testKYImageRatioIdentifierTextForCroppingOrNot() {
    //
    // forCropping = false
    XCTAssertEqual(KYImageRatioIdentifier.undefined.text(forCropping: false), "Undefined")
    XCTAssertEqual(KYImageRatioIdentifier.none.text(forCropping: false), "Fullscreen")
    // Square
    XCTAssertEqual(KYImageRatioIdentifier.square.text(forCropping: false), "Square")
    // Landscape
    XCTAssertEqual(KYImageRatioIdentifier.landscape_5_4.text(forCropping: false), "5 : 4")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_4_3.text(forCropping: false), "4 : 3")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_7_5.text(forCropping: false), "7 : 5")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_3_2.text(forCropping: false), "3 : 2")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_5_3.text(forCropping: false), "5 : 3")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_16_9.text(forCropping: false), "16 : 9")
    // Portrait
    XCTAssertEqual(KYImageRatioIdentifier.portrait_4_5.text(forCropping: false), "4 : 5")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_3_4.text(forCropping: false), "3 : 4")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_5_7.text(forCropping: false), "5 : 7")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_2_3.text(forCropping: false), "2 : 3")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_3_5.text(forCropping: false), "3 : 5")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_9_16.text(forCropping: false), "9 : 16")

    //
    // forCropping = true
    XCTAssertEqual(KYImageRatioIdentifier.undefined.text(forCropping: true), "Undefined")
    XCTAssertEqual(KYImageRatioIdentifier.none.text(forCropping: true), "Full Canvas")
    // Square
    XCTAssertEqual(KYImageRatioIdentifier.square.text(forCropping: true), "Square")
    // Landscape
    XCTAssertEqual(KYImageRatioIdentifier.landscape_5_4.text(forCropping: true), "5 : 4")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_4_3.text(forCropping: true), "4 : 3")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_7_5.text(forCropping: true), "7 : 5")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_3_2.text(forCropping: true), "3 : 2")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_5_3.text(forCropping: true), "5 : 3")
    XCTAssertEqual(KYImageRatioIdentifier.landscape_16_9.text(forCropping: true), "16 : 9")
    // Portrait
    XCTAssertEqual(KYImageRatioIdentifier.portrait_4_5.text(forCropping: true), "4 : 5")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_3_4.text(forCropping: true), "3 : 4")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_5_7.text(forCropping: true), "5 : 7")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_2_3.text(forCropping: true), "2 : 3")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_3_5.text(forCropping: true), "3 : 5")
    XCTAssertEqual(KYImageRatioIdentifier.portrait_9_16.text(forCropping: true), "9 : 16")
  }

  // MARK: - Image Thumbnail

  func testKYImageThumbnailSizeFromImageSize() throws {
    XCTAssertEqual(KYImageThumbnail.defaultMaxSideLength, 128)

    XCTAssertEqual(KYImageThumbnail.thumbnailSize(from: CGSize(width: 128, height: 128)), CGSize(width: 128, height: 128))
    XCTAssertEqual(KYImageThumbnail.thumbnailSize(from: CGSize(width: 128, height: 256)), CGSize(width: 64, height: 128))
    XCTAssertEqual(KYImageThumbnail.thumbnailSize(from: CGSize(width: 256, height: 128)), CGSize(width: 128, height: 64))
  }
}
