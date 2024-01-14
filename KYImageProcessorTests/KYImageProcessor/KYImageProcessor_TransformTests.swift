//
//  KYImageProcessor_TransformTests.swift
//  KYImageProcessorTests
//
//  Created by Kjuly on 7/11/2019.
//  Copyright © 2019 Kaijie Yu. All rights reserved.
//

import XCTest

#if os(iOS)
@testable import KYImageProcessor

final class KYImageProcessor_TransformTests: XCTestCase {

  let kKYImageProcessorTestsAccuracy: CGFloat = 0.0001

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  // MARK: - Tests - Private

  //
  // static KYImageProcessor.debug_offsetFromBoundingAreaAfterImageRotated(angle:imageSize:)
  // static KYImageProcessor._offsetFromBoundingAreaAfterImageRotated(angle:imageSize:)
  //
  func testOffsetFromBoundingAreaAfterImageRotated() throws {
    let imageSize = CGSize(width: 1000, height: 5000)
    var offset: CGPoint

    // √2 = 1.414214

    let PI: CGFloat = Double.pi
    let PI_2: CGFloat = Double.pi / 2

    //
    // I: 0 <= angle <= M_PI_2
    //
    offset = KYImageProcessor.debug_offsetFromBoundingAreaAfterImageRotated(angle: 0, imageSize: imageSize)
    XCTAssertEqual(offset.x, 0)
    XCTAssertEqual(offset.y, 0)

    offset = KYImageProcessor.debug_offsetFromBoundingAreaAfterImageRotated(angle: PI_2 / 2, imageSize: imageSize)
    XCTAssertEqual(offset.x, 2500, accuracy: kKYImageProcessorTestsAccuracy)
    XCTAssertEqual(offset.y, -2500, accuracy: kKYImageProcessorTestsAccuracy)

    offset = KYImageProcessor.debug_offsetFromBoundingAreaAfterImageRotated(angle: PI_2, imageSize: imageSize)
    XCTAssertEqual(offset.x, 0)
    XCTAssertEqual(offset.y, -5000)

    //
    // II: M_PI_2 < angle <= M_PI
    //
    offset = KYImageProcessor.debug_offsetFromBoundingAreaAfterImageRotated(angle: PI_2 + PI_2 / 2, imageSize: imageSize)
    XCTAssertEqual(offset.x, -500, accuracy: kKYImageProcessorTestsAccuracy)
    XCTAssertEqual(offset.y, -5500, accuracy: kKYImageProcessorTestsAccuracy)

    offset = KYImageProcessor.debug_offsetFromBoundingAreaAfterImageRotated(angle: PI, imageSize: imageSize)
    XCTAssertEqual(offset.x, -1000)
    XCTAssertEqual(offset.y, -5000)

    //
    // III: -M_PI <= angle < -M_PI_2
    //
    offset = KYImageProcessor.debug_offsetFromBoundingAreaAfterImageRotated(angle: -PI, imageSize: imageSize)
    XCTAssertEqual(offset.x, -1000, accuracy: kKYImageProcessorTestsAccuracy)
    XCTAssertEqual(offset.y, -5000, accuracy: kKYImageProcessorTestsAccuracy)

    offset = KYImageProcessor.debug_offsetFromBoundingAreaAfterImageRotated(angle: -PI + PI_2 / 2, imageSize: imageSize)
    XCTAssertEqual(offset.x, -3500, accuracy: kKYImageProcessorTestsAccuracy)
    XCTAssertEqual(offset.y, -2500, accuracy: kKYImageProcessorTestsAccuracy)

    //
    // IV: -M_PI_2 <= angle < 0
    //
    offset = KYImageProcessor.debug_offsetFromBoundingAreaAfterImageRotated(angle: -PI_2, imageSize: imageSize)
    XCTAssertEqual(offset.x, -1000)
    XCTAssertEqual(offset.y, 0)

    offset = KYImageProcessor.debug_offsetFromBoundingAreaAfterImageRotated(angle: -PI_2 / 2, imageSize: imageSize)
    XCTAssertEqual(offset.x, -500, accuracy: kKYImageProcessorTestsAccuracy)
    XCTAssertEqual(offset.y, 500, accuracy: kKYImageProcessorTestsAccuracy)
  }
}
#endif // END #if os(iOS)
