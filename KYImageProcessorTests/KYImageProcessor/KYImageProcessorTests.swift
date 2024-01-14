//
//  KYImageProcessorTests.swift
//  KYImageProcessorTests
//
//  Created by Kjuly on 7/11/2019.
//  Copyright © 2019 Kaijie Yu. All rights reserved.
//

import XCTest

#if os(iOS)
@testable import KYImageProcessor

final class KYImageProcessorTests: XCTestCase {

  let kKYImageProcessorTestsAccuracy: CGFloat = 0.0001

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  // MARK: - Tests - Public

  func testScaleValue() throws {
    XCTAssertEqual(KYImageProcessor.scaleValue(from: CGSize(width: 10, height: 20),
                                               to: CGSize(width: 100, height: 200)),
                   10)
    XCTAssertEqual(KYImageProcessor.scaleValue(from: CGSize(width: 10, height: 20),
                                               to: CGSize(width: 100, height: 100)),
                   10)
    XCTAssertEqual(KYImageProcessor.scaleValue(from: CGSize(width: 10, height: 20),
                                               to: CGSize(width: 200, height: 100)),
                   20)

    XCTAssertEqual(KYImageProcessor.scaleValue(from: CGSize(width: 100, height: 200),
                                               to: CGSize(width: 10, height: 20)),
                   0.1,
                   accuracy: kKYImageProcessorTestsAccuracy)

    XCTAssertEqual(KYImageProcessor.scaleValue(from: CGSize(width: 100, height: 200),
                                               to: CGSize(width: 10, height: 40)),
                   0.2,
                   accuracy: kKYImageProcessorTestsAccuracy)

    XCTAssertEqual(KYImageProcessor.scaleValue(from: CGSize(width: 100, height: 200),
                                               to: CGSize(width: 20, height: 20)),
                   0.2,
                   accuracy: kKYImageProcessorTestsAccuracy)
  }

  // MARK: Tests - Internal

  //
  // static KYImageProcessor.debug_revisedFrame(_:with:)
  // static KYImageProcessor.p_revisedFrame(_:with:)
  //
  func testRevisedFrame() throws {
    var frame: CGRect
    var boudningFrame: CGRect

    boudningFrame = CGRect(x: 0, y: 0, width: 500, height: 1000)

    frame = CGRect(x: 0.01, y: 0.01, width: 499, height: 999)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: 0.01, y: 0.01, width: 499.1, height: 999.1)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: 0.1, y: 0.1, width: 499.1, height: 999.1)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: 0.1, y: 0.1, width: 499.4, height: 999.4)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: 0.1, y: 0.1, width: 499.9, height: 999.9)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: -0.1, y: -0.1, width: 499.9, height: 999.9)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: -0.1, y: -0.1, width: 500.1, height: 1000.1)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 500, height: 1000))

    frame = CGRect(x: 1.1, y: 1.1, width: 499.1, height: 999.1)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 1, y: 1, width: 499, height: 999))

    frame = CGRect(x: 1.1, y: 1.1, width: 500.1, height: 1000.1)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 1, y: 1, width: 499, height: 999))

    frame = CGRect(x: 1.1, y: 1.1, width: 500, height: 1000)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 1, y: 1, width: 499, height: 999))

    frame = CGRect(x: 4.1, y: 4.6, width: 496, height: 996)
    XCTAssertEqual(KYImageProcessor.debug_revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 4, y: 4, width: 496, height: 996))
  }
}
#endif // END #if os(iOS)
