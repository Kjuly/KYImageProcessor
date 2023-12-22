//
//  KYImageProcessingLocalizations.swift
//  KYImageProcessing
//
//  Created by Kjuly on 22/12/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

#if KY_IMAGE_PROCESSING_FRAMEWORK

extension String {
  var ky_imageProcessingLocalized: String {
    return NSLocalizedString(self,
                             tableName: "KYImageProcessingLocalizations",
                             bundle: Bundle(identifier: "com.kjuly.KYImageProcessing") ?? Bundle.main,
                             value: "",
                             comment: "")
  }
}

#else

extension String {
  var ky_imageProcessingLocalized: String {
    return NSLocalizedString(self, tableName: "KYImageProcessingLocalizations", bundle: .module, value: "", comment: "")
  }
}

#endif
