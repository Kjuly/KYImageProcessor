//
//  KYImageThumbnail.swift
//  KYImageProcessor
//
//  Created by Kjuly on 22/12/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

public struct KYImageThumbnail {

  public static let defaultMaxSideLength: CGFloat = 128.0

  public static func thumbnailSize(
    from imageSize: CGSize,
    maxSideLength: CGFloat
  ) -> CGSize {
    return (imageSize.height > imageSize.width
            ? CGSize(width: imageSize.width * maxSideLength / imageSize.height, height: maxSideLength)
            : CGSize(width: maxSideLength, height: imageSize.height * maxSideLength / imageSize.width))
  }

  public static func thumbnailSize(from imageSize: CGSize) -> CGSize {
    return thumbnailSize(from: imageSize, maxSideLength: defaultMaxSideLength)
  }
}

// MARK: - ObjC

@objcMembers
public class KYImageThumbnailObjC: NSObject {

  public static func thumbnailSize(from imageSize: CGSize) -> CGSize {
    return KYImageThumbnail.thumbnailSize(from: imageSize)
  }
}
