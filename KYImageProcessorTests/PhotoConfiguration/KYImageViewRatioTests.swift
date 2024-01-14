//
//  KYImageViewRatioTests.swift
//  KYImageProcessorTests
//
//  Created by Kjuly on 15/6/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYImageProcessor

final class KYImageViewRatioTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testMakeKYImageViewRatio() throws {
    let viewRatio = KYImageViewRatio(w: 123.0, h: 456.0)
    XCTAssertEqual(viewRatio.w, 123.0)
    XCTAssertEqual(viewRatio.h, 456.0)
  }

  func testMakeKYImageViewRatioFromRatioIdentifier() throws {
    var viewRatio = KYImageViewRatio(from: KYImageRatioIdentifier.square)
    XCTAssertEqual(viewRatio.w, 1)
    XCTAssertEqual(viewRatio.h, 1)

    viewRatio = KYImageViewRatio(from: KYImageRatioIdentifier.portrait_9_16)
    XCTAssertEqual(viewRatio.w, 9)
    XCTAssertEqual(viewRatio.h, 16)

    viewRatio = KYImageViewRatio(from: KYImageRatioIdentifier.landscape_16_9)
    XCTAssertEqual(viewRatio.w, 16)
    XCTAssertEqual(viewRatio.h, 9)
  }

  func testRatioIdentifierFromKYImageViewRatio() throws {
    var viewRatio = KYImageViewRatio(w: 1, h: 1)
    XCTAssertEqual(viewRatio.ratioIdentifier(), KYImageRatioIdentifier.square)

    viewRatio = KYImageViewRatio(w: 16, h: 9)
    XCTAssertEqual(viewRatio.ratioIdentifier(), KYImageRatioIdentifier.landscape_16_9)

    viewRatio = KYImageViewRatio(w: 9, h: 16)
    XCTAssertEqual(viewRatio.ratioIdentifier(), KYImageRatioIdentifier.portrait_9_16)

    viewRatio = KYImageViewRatio(w: 11, h: 8)
    XCTAssertEqual(viewRatio.ratioIdentifier(), KYImageRatioIdentifier.undefined)
  }

  func testKYImageViewRatioScaleAspectFitSize() throws {
    let sizeAtMax = CGSize(width: 100, height: 200)
    var viewRatio: KYImageViewRatio

    viewRatio = KYImageViewRatio(w: 0, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYImageViewRatio(w: 1, h: 0)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYImageViewRatio(w: 1, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 100))

    viewRatio = KYImageViewRatio(w: 1, h: 2)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYImageViewRatio(w: 1, h: 4)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 50, height: 200))

    viewRatio = KYImageViewRatio(w: 2, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 50))

    viewRatio = KYImageViewRatio(w: 4, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFitSize(with: sizeAtMax), CGSize(width: 100, height: 25))
  }

  func testKYImageViewRatioScaleAspectFillSize() throws {
    let sizeAtMax = CGSize(width: 100, height: 200)
    var viewRatio: KYImageViewRatio

    viewRatio = KYImageViewRatio(w: 0, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYImageViewRatio(w: 1, h: 0)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYImageViewRatio(w: 1, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 200, height: 200))

    viewRatio = KYImageViewRatio(w: 1, h: 2)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 100, height: 200))

    viewRatio = KYImageViewRatio(w: 1, h: 4)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 100, height: 400))

    viewRatio = KYImageViewRatio(w: 2, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 400, height: 200))

    viewRatio = KYImageViewRatio(w: 4, h: 1)
    XCTAssertEqual(viewRatio.scaleAspectFillSize(with: sizeAtMax), CGSize(width: 800, height: 200))
  }
}
