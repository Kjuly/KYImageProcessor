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

  // MARK: - Image Ratio

  func testKYImageRatioIdentifier() throws {
    XCTAssertEqual(KYImageRatioIdentifier.unknown.rawValue, -1)
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

  // MARK: - Image Scale Mode

  func testKYImageScaleMode() throws {
    XCTAssertEqual(KYImageScaleMode.scaleAspectFill.rawValue, 0)
    XCTAssertEqual(KYImageScaleMode.scaleAspectFit.rawValue, 1)
  }

  // MARK: - Image Thumbnail

  func testKYImageThumbnailSizeFromImageSize() throws {
    XCTAssertEqual(KYImageThumbnail.defaultMaxSideLength, 128)

    XCTAssertEqual(KYImageThumbnail.thumbnailSize(from: CGSize(width: 128, height: 128)), CGSize(width: 128, height: 128))
    XCTAssertEqual(KYImageThumbnail.thumbnailSize(from: CGSize(width: 128, height: 256)), CGSize(width: 64, height: 128))
    XCTAssertEqual(KYImageThumbnail.thumbnailSize(from: CGSize(width: 256, height: 128)), CGSize(width: 128, height: 64))
  }
}
