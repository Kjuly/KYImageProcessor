//
//  KYImageTransformerTests.swift
//  KYImageProcessingTests
//
//  Created by Kjuly on 7/11/2019.
//  Copyright © 2019 Kaijie Yu. All rights reserved.
//

import XCTest

#if os(iOS)
@testable import KYImageProcessing

final class KYImageTransformerTests: XCTestCase {

  let kYNPhotoImageTransformerTestsAccuracy: CGFloat = 0.0001

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  // MARK: Tests for Private Methods

  func testRevisedFrame() throws {
    var frame: CGRect
    var boudningFrame: CGRect

    boudningFrame = CGRect(x: 0, y: 0, width: 500, height: 1000)

    frame = CGRect(x: 0.01, y: 0.01, width: 499, height: 999)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: 0.01, y: 0.01, width: 499.1, height: 999.1)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: 0.1, y: 0.1, width: 499.1, height: 999.1)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: 0.1, y: 0.1, width: 499.4, height: 999.4)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: 0.1, y: 0.1, width: 499.9, height: 999.9)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: -0.1, y: -0.1, width: 499.9, height: 999.9)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 499, height: 999))

    frame = CGRect(x: -0.1, y: -0.1, width: 500.1, height: 1000.1)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 0, y: 0, width: 500, height: 1000))

    frame = CGRect(x: 1.1, y: 1.1, width: 499.1, height: 999.1)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 1, y: 1, width: 499, height: 999))

    frame = CGRect(x: 1.1, y: 1.1, width: 500.1, height: 1000.1)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 1, y: 1, width: 499, height: 999))

    frame = CGRect(x: 1.1, y: 1.1, width: 500, height: 1000)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 1, y: 1, width: 499, height: 999))

    frame = CGRect(x: 4.1, y: 4.6, width: 496, height: 996)
    XCTAssertEqual(KYImageTransformer.revisedFrame(frame, with: boudningFrame),
                   CGRect(x: 4, y: 4, width: 496, height: 996))
  }

  func testOffsetFromBoundingAreaAfterImageRotated() throws {
    let imageSize = CGSize(width: 1000, height: 5000)
    var offset: CGPoint

    // √2 = 1.414214

    let PI: CGFloat = Double.pi
    let PI_2: CGFloat = Double.pi / 2

    //
    // I: 0 <= angle <= M_PI_2
    //
    offset = KYImageTransformer.offsetFromBoundingAreaAfterImageRotated(angle: 0, imageSize: imageSize)
    XCTAssertEqual(offset.x, 0)
    XCTAssertEqual(offset.y, 0)

    offset = KYImageTransformer.offsetFromBoundingAreaAfterImageRotated(angle: PI_2 / 2, imageSize: imageSize)
    XCTAssertEqual(offset.x, 2500, accuracy: kYNPhotoImageTransformerTestsAccuracy)
    XCTAssertEqual(offset.y, -2500, accuracy: kYNPhotoImageTransformerTestsAccuracy)

    offset = KYImageTransformer.offsetFromBoundingAreaAfterImageRotated(angle: PI_2, imageSize: imageSize)
    XCTAssertEqual(offset.x, 0)
    XCTAssertEqual(offset.y, -5000)

    //
    // II: M_PI_2 < angle <= M_PI
    //
    offset = KYImageTransformer.offsetFromBoundingAreaAfterImageRotated(angle: PI_2 + PI_2 / 2, imageSize: imageSize)
    XCTAssertEqual(offset.x, -500, accuracy: kYNPhotoImageTransformerTestsAccuracy)
    XCTAssertEqual(offset.y, -5500, accuracy: kYNPhotoImageTransformerTestsAccuracy)

    offset = KYImageTransformer.offsetFromBoundingAreaAfterImageRotated(angle: PI, imageSize: imageSize)
    XCTAssertEqual(offset.x, -1000)
    XCTAssertEqual(offset.y, -5000)

    //
    // III: -M_PI <= angle < -M_PI_2
    //
    offset = KYImageTransformer.offsetFromBoundingAreaAfterImageRotated(angle: -PI, imageSize: imageSize)
    XCTAssertEqual(offset.x, -1000, accuracy: kYNPhotoImageTransformerTestsAccuracy)
    XCTAssertEqual(offset.y, -5000, accuracy: kYNPhotoImageTransformerTestsAccuracy)

    offset = KYImageTransformer.offsetFromBoundingAreaAfterImageRotated(angle: -PI + PI_2 / 2, imageSize: imageSize)
    XCTAssertEqual(offset.x, -3500, accuracy: kYNPhotoImageTransformerTestsAccuracy)
    XCTAssertEqual(offset.y, -2500, accuracy: kYNPhotoImageTransformerTestsAccuracy)

    //
    // IV: -M_PI_2 <= angle < 0
    //
    offset = KYImageTransformer.offsetFromBoundingAreaAfterImageRotated(angle: -PI_2, imageSize: imageSize)
    XCTAssertEqual(offset.x, -1000)
    XCTAssertEqual(offset.y, 0)

    offset = KYImageTransformer.offsetFromBoundingAreaAfterImageRotated(angle: -PI_2 / 2, imageSize: imageSize)
    XCTAssertEqual(offset.x, -500, accuracy: kYNPhotoImageTransformerTestsAccuracy)
    XCTAssertEqual(offset.y, 500, accuracy: kYNPhotoImageTransformerTestsAccuracy)
  }

  // MARK: - Tests for Public Methods

  func testScaleValue() throws {
    XCTAssertEqual(KYImageTransformer.scaleValue(from: CGSize(width: 10, height: 20),
                                                 to: CGSize(width: 100, height: 200)),
                   10)
    XCTAssertEqual(KYImageTransformer.scaleValue(from: CGSize(width: 10, height: 20),
                                                 to: CGSize(width: 100, height: 100)),
                   10)
    XCTAssertEqual(KYImageTransformer.scaleValue(from: CGSize(width: 10, height: 20),
                                                 to: CGSize(width: 200, height: 100)),
                   20)

    XCTAssertEqual(KYImageTransformer.scaleValue(from: CGSize(width: 100, height: 200),
                                                 to: CGSize(width: 10, height: 20)),
                   0.1,
                   accuracy: kYNPhotoImageTransformerTestsAccuracy)

    XCTAssertEqual(KYImageTransformer.scaleValue(from: CGSize(width: 100, height: 200),
                                                 to: CGSize(width: 10, height: 40)),
                   0.2,
                   accuracy: kYNPhotoImageTransformerTestsAccuracy)

    XCTAssertEqual(KYImageTransformer.scaleValue(from: CGSize(width: 100, height: 200),
                                                 to: CGSize(width: 20, height: 20)),
                   0.2,
                   accuracy: kYNPhotoImageTransformerTestsAccuracy)
  }
}
#endif // END #if os(iOS)
