//
//  KYPhotoThumbnail.swift
//  KYImageProcessor
//
//  Created by Kjuly on 22/12/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

@objc
public class KYPhotoThumbnail: NSObject {

  public static let defaultMaxSideLength: CGFloat = 128.0

  public static func thumbnailSize(
    from imageSize: CGSize,
    maxSideLength: CGFloat
  ) -> CGSize {
    return (imageSize.height > imageSize.width
            ? CGSize(width: imageSize.width * maxSideLength / imageSize.height, height: maxSideLength)
            : CGSize(width: maxSideLength, height: imageSize.height * maxSideLength / imageSize.width))
  }

  @objc
  public static func thumbnailSize(from imageSize: CGSize) -> CGSize {
    return thumbnailSize(from: imageSize, maxSideLength: defaultMaxSideLength)
  }
}
