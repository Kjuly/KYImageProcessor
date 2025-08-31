//
//  KYImageProcessorLocalizations.swift
//  KYImageProcessor
//
//  Created by Kjuly on 22/12/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

#if KY_IMAGE_PROCESSING_FRAMEWORK

extension String {
  public var ky_imageProcessorLocalized: String {
    NSLocalizedString(
      self,
      tableName: "KYImageProcessorLocalizations",
      bundle: Bundle(identifier: "com.kjuly.KYImageProcessor") ?? Bundle.main,
      value: "",
      comment: ""
    )
  }
}

#else

extension String {
  public var ky_imageProcessorLocalized: String {
    NSLocalizedString(self, tableName: "KYImageProcessorLocalizations", bundle: .module, value: "", comment: "")
  }
}

#endif
