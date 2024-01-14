//
//  KYImageViewRatio.swift
//  KYImageProcessor
//
//  Created by Kjuly on 15/6/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

public struct KYImageViewRatio {

  public let w: CGFloat
  public let h: CGFloat

  // MARK: - Init

  public init(w: CGFloat, h: CGFloat) {
    self.w = w
    self.h = h
  }

  public init(from ratioIdentifier: KYImageRatioIdentifier) {
    let rawValue = ratioIdentifier.rawValue
    self.init(w: CGFloat(rawValue % 1000000 / 1000), h: CGFloat(rawValue % 1000))
  }

  // MARK: - Public

  public func ratioIdentifier() -> KYImageRatioIdentifier {
    let rawValue = Int(self.w * 1000) + Int(self.h)
    if let identifier = KYImageRatioIdentifier(rawValue: rawValue) {
      return identifier
    } else {
      return .unknown
    }
  }

  public func scaleAspectFitSize(with sizeAtMax: CGSize) -> CGSize {
    // fullscreen
    if self.w == 0 || self.h == 0 {
      return sizeAtMax
    }
    // < 1.f, fixed height, adjust width.
    else if self.w / self.h < sizeAtMax.width / sizeAtMax.height {
      return CGSize(width: sizeAtMax.height * self.w / self.h, height: sizeAtMax.height)
    }
    // >= 1.f, fixed width, adjust height.
    else {
      return CGSize(width: sizeAtMax.width, height: sizeAtMax.width * self.h / self.w)
    }
  }

  public func scaleAspectFillSize(with sizeAtMax: CGSize) -> CGSize {
    // fullscreen
    if self.w == 0 || self.h == 0 {
      return sizeAtMax
    }
    // < 1.f, fixed width, adjust height
    else if self.w / self.h < sizeAtMax.width / sizeAtMax.height {
      return CGSize(width: sizeAtMax.width, height: sizeAtMax.width * self.h / self.w)
    }
    // >= 1.f, fixed height, adjust width.
    else {
      return CGSize(width: sizeAtMax.height * self.w / self.h, height: sizeAtMax.height)
    }
  }
}
