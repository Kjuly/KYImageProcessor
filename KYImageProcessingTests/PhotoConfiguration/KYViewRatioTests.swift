//
//  KYViewRatioTests.swift
//  KYImageProcessingTests
//
//  Created by Kjuly on 15/6/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYImageProcessing

final class KYViewRatioTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testMakeKYViewRatio() throws {
    let viewRatio = KYViewRatio(w: 123.0, h: 456.0)
    XCTAssertEqual(viewRatio.w, 123.0)
    XCTAssertEqual(viewRatio.h, 456.0)
  }

  func testMakeKYViewRatioFromRatioIdentifier() throws {
    var viewRatio = KYViewRatio(from: KYPhotoRatioIdentifier.square)
    XCTAssertEqual(viewRatio.w, 1)
    XCTAssertEqual(viewRatio.h, 1)

    viewRatio = KYViewRatio(from: KYPhotoRatioIdentifier.portrait_9_16)
    XCTAssertEqual(viewRatio.w, 9)
    XCTAssertEqual(viewRatio.h, 16)

    viewRatio = KYViewRatio(from: KYPhotoRatioIdentifier.landscape_16_9)
    XCTAssertEqual(viewRatio.w, 16)
    XCTAssertEqual(viewRatio.h, 9)
  }

  func testRatioIdentifierFromKYViewRatio() throws {
    var viewRatio = KYViewRatio(w: 1, h: 1)
    XCTAssertEqual(viewRatio.ratioIdentifier(), KYPhotoRatioIdentifier.square)

    viewRatio = KYViewRatio(w: 16, h: 9)
    XCTAssertEqual(viewRatio.ratioIdentifier(), KYPhotoRatioIdentifier.landscape_16_9)

    viewRatio = KYViewRatio(w: 9, h: 16)
    XCTAssertEqual(viewRatio.ratioIdentifier(), KYPhotoRatioIdentifier.portrait_9_16)

    viewRatio = KYViewRatio(w: 11, h: 8)
    XCTAssertEqual(viewRatio.ratioIdentifier(), KYPhotoRatioIdentifier.unknown)
  }

  func testKYViewRatioScaleAspectFitSize() throws {
    let sizeAtMax = CGSize(width: 100, height: 200)
    var viewRatio: KYViewRatio

    viewRatio = KYViewRatio(w: 0, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYViewRatio(w: 1, h: 0)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYViewRatio(w: 1, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 100))

    viewRatio = KYViewRatio(w: 1, h: 2)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYViewRatio(w: 1, h: 4)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 50, height: 200))

    viewRatio = KYViewRatio(w: 2, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 50))

    viewRatio = KYViewRatio(w: 4, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 25))
  }

  func testKYViewRatioScaleAspectFillSize() throws {
    let sizeAtMax = CGSize(width: 100, height: 200)
    var viewRatio: KYViewRatio

    viewRatio = KYViewRatio(w: 0, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYViewRatio(w: 1, h: 0)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYViewRatio(w: 1, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 200, height: 200))

    viewRatio = KYViewRatio(w: 1, h: 2)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYViewRatio(w: 1, h: 4)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 100, height: 400))

    viewRatio = KYViewRatio(w: 2, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 400, height: 200))

    viewRatio = KYViewRatio(w: 4, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 800, height: 200))
  }
}
