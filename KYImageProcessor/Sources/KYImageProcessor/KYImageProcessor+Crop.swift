//
//  KYImageProcessor+Crop.swift
//  KYImageProcessor
//
//  Created by Kjuly on 24/10/2019.
//  Copyright © 2019 Kaijie Yu. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit

extension KYImageProcessor {

  // MARK: - Public

  /// Crop an image.
  ///
  /// - Parameters:
  ///   - image: Image to crop
  ///   - cropFrame: Fullscreen image size as the final render convas size.
  ///   - canvasFrame: Canvas frame.
  ///   - scale: Scale value from canvasViewSize to fullscreenImageSize.
  ///
  /// - Returns: A cropped image.
  ///
  public static func cropImage(
    _ image: UIImage,
    with cropFrame: CGRect,
    canvasFrame: CGRect,
    scale: CGFloat
  ) -> UIImage {

    let cropSize: CGSize = cropFrame.size
    let cropOriginRelativeToCanvas = CGPoint(x: cropFrame.minX - canvasFrame.minX,
                                             y: cropFrame.minY - canvasFrame.minY)
    var cropRect: CGRect

    // Scale cropRect to handle images larger than shown-on-screen size
    var IMAGE_SIZE: CGSize
    if image.imageOrientation == .up || image.imageOrientation == .down {
      IMAGE_SIZE = image.size
      // New generated image is in portrait, so just get crop rect in common way.
      cropRect = CGRect(x: cropOriginRelativeToCanvas.x * scale,
                        y: cropOriginRelativeToCanvas.y * scale,
                        width: cropSize.width * scale,
                        height: cropSize.height * scale)
    } else {
      IMAGE_SIZE = CGSize(width: image.size.height, height: image.size.width)
      /*
       * The source image is in landscape (left side is the top that we expected,
       *   and the image height is the width we expected).
       *
       * REF TO: +rawPhotoImageFromCaptureredSourceImage:...
       */
      cropRect = CGRect(x: cropOriginRelativeToCanvas.y * scale,
                        y: (canvasFrame.size.width - (cropOriginRelativeToCanvas.x + cropSize.width)) * scale,
                        width: cropSize.height * scale,
                        height: cropSize.width * scale)
    }
    KYIPLog("\n# Revising Crop Rect ...")
    cropRect = p_revisedFrame(cropRect, with: CGRect(origin: .zero, size: IMAGE_SIZE))

    //
    // Perform cropping in Core Graphics
    //
    // Obj-C:
    //   CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect)
    //
    var croppedImage: UIImage?
    if let croppedImageRef: CGImage = image.cgImage?.cropping(to: cropRect) {
      croppedImage = UIImage(cgImage: croppedImageRef, scale: image.scale, orientation: image.imageOrientation)
    }
    KYIPLog("""
  - canvasFrame: \(canvasFrame)
  - crop frame relative to canvas: \(CGRect(origin: cropOriginRelativeToCanvas, size: cropSize))
  - IMAGE_SIZE: \(IMAGE_SIZE)
  - cropRect: \(cropRect)
  - croppedImage.size: \(croppedImage?.size ?? .zero)
""")
    return croppedImage ?? image
  }
}
#endif // END #if os(iOS)
