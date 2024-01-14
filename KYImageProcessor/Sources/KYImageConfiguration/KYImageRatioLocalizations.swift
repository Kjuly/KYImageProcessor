//
//  KYImageRatioLocalizations.swift
//  KYImageProcessor
//
//  Created by Kaijie Yu on 3/6/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

public struct KYImageRatioLocalizations {

  // swiftlint:disable:next cyclomatic_complexity
  public static func textOfPhotoRatio(
    with identifier: KYImageRatioIdentifier,
    forCropping: Bool = false
  ) -> String {

    var key: String
    switch identifier {
    case .none: key = (forCropping ? "KYLS:Image Ratio:Full Canvas" : "KYLS:Image Ratio:Fullscreen")
    case .square: key = "KYLS:Image Ratio:Square"
      // Landscape
    case .landscape_5_4: key = "KYLS:Image Ratio:5_4"
    case .landscape_4_3: key = "KYLS:Image Ratio:4_3"
    case .landscape_7_5: key = "KYLS:Image Ratio:7_5"
    case .landscape_3_2: key = "KYLS:Image Ratio:3_2"
    case .landscape_5_3: key = "KYLS:Image Ratio:5_3"
    case .landscape_16_9: key = "KYLS:Image Ratio:16_9"
      // Portrait
    case .portrait_4_5: key = "KYLS:Image Ratio:Portrait:4_5"
    case .portrait_3_4: key = "KYLS:Image Ratio:Portrait:3_4"
    case .portrait_5_7: key = "KYLS:Image Ratio:Portrait:5_7"
    case .portrait_2_3: key = "KYLS:Image Ratio:Portrait:2_3"
    case .portrait_3_5: key = "KYLS:Image Ratio:Portrait:3_5"
    case .portrait_9_16: key = "KYLS:Image Ratio:Portrait:9_16"
    default:
      key = "KYLS:Image Ratio:Fullscreen"
    }
    return key.ky_imageProcessorLocalized
  }
}
