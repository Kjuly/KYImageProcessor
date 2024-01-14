//
//  KYImageConfiguration.swift
//  KYImageProcessor
//
//  Created by Kjuly on 15/6/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: - Image Resolution

public enum KYImageResolution: Int {
  case original = 0
  case high     = 1
  case medium   = 2
  case low      = 3
}

// MARK: - Image Scale Mode

public enum KYImageScaleMode: Int {
  case scaleAspectFill = 0
  case scaleAspectFit  = 1
}

// MARK: - Image Ratio

@objc
public enum KYImageRatioIdentifier: Int {
  case undefined = -1

  /// Stands "Fullscreen" for "Camera Capture View Ratio" & "Photo Canvas Ratio"
  ///   "Full Canvas" for "Photo Crop Ratio".
  case none = 0

  /// Square
  case square = 1001 // 1:1

  // Landscape
  case landscape_5_4  =  5004 //  5:4
  case landscape_4_3  =  4003 //  4:3
  case landscape_7_5  =  7005 //  7:5
  case landscape_3_2  =  3002 //  3:2
  case landscape_5_3  =  5003 //  5:3
  case landscape_16_9 = 16009 // 16:9

  // Portrait
  case portrait_4_5  = 4005 // 4:5
  case portrait_3_4  = 3004 // 3:4
  case portrait_5_7  = 5007 // 5:7
  case portrait_2_3  = 2003 // 2:3
  case portrait_3_5  = 3005 // 3:5
  case portrait_9_16 = 9016 // 9:16

  // MARK: - Text Key of Image Ratio

  public var textKey: String {
    switch self {
    case .none: return "KYLS:Image Ratio:Fullscreen"
    case .square: return "KYLS:Image Ratio:Square"
      // Landscape
    case .landscape_5_4: return "KYLS:Image Ratio:5_4"
    case .landscape_4_3: return "KYLS:Image Ratio:4_3"
    case .landscape_7_5: return "KYLS:Image Ratio:7_5"
    case .landscape_3_2: return "KYLS:Image Ratio:3_2"
    case .landscape_5_3: return "KYLS:Image Ratio:5_3"
    case .landscape_16_9: return "KYLS:Image Ratio:16_9"
      // Portrait
    case .portrait_4_5: return "KYLS:Image Ratio:Portrait:4_5"
    case .portrait_3_4: return "KYLS:Image Ratio:Portrait:3_4"
    case .portrait_5_7: return "KYLS:Image Ratio:Portrait:5_7"
    case .portrait_2_3: return "KYLS:Image Ratio:Portrait:2_3"
    case .portrait_3_5: return "KYLS:Image Ratio:Portrait:3_5"
    case .portrait_9_16: return "KYLS:Image Ratio:Portrait:9_16"
    default:
      return "KYLS:Image Ratio:Undefined"
    }
  }

  // MARK: - Text of Image Ratio

  public var text: String {
    return self.textKey.ky_imageProcessorLocalized
  }

  public func text(forCropping: Bool) -> String {
    if forCropping && self == .none {
      return "KYLS:Image Ratio:Full Canvas".ky_imageProcessorLocalized
    } else {
      return self.text
    }
  }
}
