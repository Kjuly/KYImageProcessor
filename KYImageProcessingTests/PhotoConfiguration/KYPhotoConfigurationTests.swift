//
//  KYPhotoConfigurationTests.swift
//  KYImageProcessingTests
//
//  Created by Kjuly on 15/6/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYImageProcessing

final class KYPhotoConfigurationTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  // MARK: - Photo Resolution

  func testKYPhotoResolution() throws {
    XCTAssertEqual(KYPhotoResolution.original.rawValue, 0)
    XCTAssertEqual(KYPhotoResolution.high.rawValue, 1)
    XCTAssertEqual(KYPhotoResolution.medium.rawValue, 2)
    XCTAssertEqual(KYPhotoResolution.low.rawValue, 3)
  }

  // MARK: - Photo Ratio

  func testKYPhotoRatioIdentifier() throws {
    XCTAssertEqual(KYPhotoRatioIdentifier.unknown.rawValue, -1)
    XCTAssertEqual(KYPhotoRatioIdentifier.none.rawValue, 0)
    // Square
    XCTAssertEqual(KYPhotoRatioIdentifier.square.rawValue, 1001)
    // Landscape
    XCTAssertEqual(KYPhotoRatioIdentifier.landscape_5_4.rawValue, 5004)
    XCTAssertEqual(KYPhotoRatioIdentifier.landscape_4_3.rawValue, 4003)
    XCTAssertEqual(KYPhotoRatioIdentifier.landscape_7_5.rawValue, 7005)
    XCTAssertEqual(KYPhotoRatioIdentifier.landscape_3_2.rawValue, 3002)
    XCTAssertEqual(KYPhotoRatioIdentifier.landscape_5_3.rawValue, 5003)
    XCTAssertEqual(KYPhotoRatioIdentifier.landscape_16_9.rawValue, 16009)
    // Portrait
    XCTAssertEqual(KYPhotoRatioIdentifier.portrait_4_5.rawValue, 4005)
    XCTAssertEqual(KYPhotoRatioIdentifier.portrait_3_4.rawValue, 3004)
    XCTAssertEqual(KYPhotoRatioIdentifier.portrait_5_7.rawValue, 5007)
    XCTAssertEqual(KYPhotoRatioIdentifier.portrait_2_3.rawValue, 2003)
    XCTAssertEqual(KYPhotoRatioIdentifier.portrait_3_5.rawValue, 3005)
    XCTAssertEqual(KYPhotoRatioIdentifier.portrait_9_16.rawValue, 9016)
  }

  // MARK: - Photo Scale Mode

  func testKYPhotoScaleMode() throws {
    XCTAssertEqual(KYPhotoScaleMode.scaleAspectFill.rawValue, 0)
    XCTAssertEqual(KYPhotoScaleMode.scaleAspectFit.rawValue, 1)
  }

  // MARK: - Photo Thumbnail

  func testKYPhotoThumbnailSizeFromImageSize() throws {
    XCTAssertEqual(KYPhotoThumbnail.defaultMaxSideLength, 128)

    XCTAssertEqual(KYPhotoThumbnail.thumbnailSize(from: CGSize(width: 128, height: 128)), CGSize(width: 128, height: 128))
    XCTAssertEqual(KYPhotoThumbnail.thumbnailSize(from: CGSize(width: 128, height: 256)), CGSize(width: 64, height: 128))
    XCTAssertEqual(KYPhotoThumbnail.thumbnailSize(from: CGSize(width: 256, height: 128)), CGSize(width: 128, height: 64))
  }
}
