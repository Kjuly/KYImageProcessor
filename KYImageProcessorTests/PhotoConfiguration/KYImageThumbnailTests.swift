//
//  KYImageThumbnailTests.swift
//  KYImageProcessorTests
//
//  Created by Kjuly on 15/6/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYImageProcessor

final class KYImageThumbnailTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testThumbnailSizeFromImageSize() throws {
    XCTAssertEqual(KYImageThumbnail.defaultMaxSideLength, 128)

    XCTAssertEqual(KYImageThumbnail.thumbnailSize(from: CGSize(width: 128, height: 128)), CGSize(width: 128, height: 128))
    XCTAssertEqual(KYImageThumbnail.thumbnailSize(from: CGSize(width: 128, height: 256)), CGSize(width: 64, height: 128))
    XCTAssertEqual(KYImageThumbnail.thumbnailSize(from: CGSize(width: 256, height: 128)), CGSize(width: 128, height: 64))
  }

  // MARK: - Tests for KYImageThumbnailObjC

  func testThumbnailSizeFromImageSize_ObjC() throws {
    XCTAssertEqual(KYImageThumbnailObjC.thumbnailSize(from: CGSize(width: 128, height: 128)), CGSize(width: 128, height: 128))
    XCTAssertEqual(KYImageThumbnailObjC.thumbnailSize(from: CGSize(width: 128, height: 256)), CGSize(width: 64, height: 128))
    XCTAssertEqual(KYImageThumbnailObjC.thumbnailSize(from: CGSize(width: 256, height: 128)), CGSize(width: 128, height: 64))
  }
}
