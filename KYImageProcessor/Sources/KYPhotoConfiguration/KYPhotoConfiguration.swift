//
//  KYPhotoConfiguration.swift
//  KYImageProcessor
//
//  Created by Kjuly on 15/6/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: - Photo Resolution

public enum KYPhotoResolution: Int {
  case original = 0
  case high     = 1
  case medium   = 2
  case low      = 3
}

// MARK: - Photo Ratio

@objc
public enum KYPhotoRatioIdentifier: Int {
  case unknown = -1

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
}

// MARK: - Photo Scale Mode

public enum KYPhotoScaleMode: Int {
  case scaleAspectFill = 0
  case scaleAspectFit  = 1
}
