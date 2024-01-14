//
//  KYImageProcessor.swift
//  KYImageProcessor
//
//  Created by Kjuly on 24/10/2019.
//  Copyright © 2019 Kaijie Yu. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit

public struct KYImageProcessor {

  #if DEBUG
  static let DEBUG_CROPPING_IMAGE_: Bool = false
  #endif

  // MARK: - Public

  /// Get the scale value from `sizeFrom` to `sizeTo`, the larger of "`sizeTo.width / sizeFrom.width`"
  ///   and "`sizeTo.height / sizeTo.height`" will be returned.
  public static func scaleValue(from sizeFrom: CGSize, to sizeTo: CGSize) -> CGFloat {
    return max(sizeTo.width / sizeFrom.width, sizeTo.height / sizeFrom.height)
  }

  /// Generate a raw image from a captured photo image, which is an unedited image captured from the Camera
  ///   using AVFoundation customization.
  ///
  /// Will be used at `-[AVCapturePhotoCaptureDelegate captureOutput:didFinishProcessingPhoto:error:]`, e.g.:
  /// ```swift
  /// func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
  ///   guard
  ///     let capturedImageData: Data = photo.fileDataRepresentation(),
  ///     let capturedImage = UIImage(data: capturedImageData)
  ///   else {
  ///     return
  ///   }
  ///
  ///   let imageOrientation: UIImage.Orientation = (self.captureDevicePosition == .front ? .leftMirrored : sourceImage.imageOrientation)
  ///   let image: UIImage = KYImageProcessor.rawImage(
  ///     from: sourceImage,
  ///     in: imageOrientation,
  ///     with: self.viewSize,
  ///     cameraCaptureViewFrameInRatio: self.cameraCaptureViewFrameInRatio)
  ///   // ... deal with the `image`.
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - capturedPhotoImage: Unedited photo image that captured from the Camera.
  ///   - orientation: The orientation for the captured photo image.
  ///   - fullscreenViewSize: Fullscreen view size of the current device.
  ///   - cameraCaptureViewFrameInRatio: Camera capture view frame in ratio (expected raw image size in ratio)
  ///
  /// - Returns: A image that's ready to use.
  ///
  public static func image(
    from capturedPhotoImage: UIImage,
    in orientation: UIImage.Orientation,
    with fullscreenViewSize: CGSize,
    cameraCaptureViewFrameInRatio: CGRect
  ) -> UIImage {
    //
    // Crop source image.
    //
    // The source image is in landscape (left side is the top that we expected,
    //   and the image height is the width we expected).
    //
    // Source Image (Landscape) | Display Image (Portrait)
    //                          |
    //                          |      pW                      W: Raw Image Width
    //      H | cW              |    ------                    H: Raw Image Height
    //  ------------            |   |      |
    // |            | W | cH    |   |      | pH               cW: cropWidth
    // |            |           |   |      |                  cH: cropHeight
    //  ------------            |   |      |
    //                          |    ------                   pW: previewImageWidth
    //                          |                             pH: previewImageHeight
    //
    // ratio = H / W
    //
    // IF (pH / pW <= ratio):
    //    1. cH = W
    //    2. pW / pH = cH / cW
    //    => pW / pH =  W / cW
    //    => cW = pH * W / pW
    //
    //    cropRect.origin.x = (H - cW) / 2
    //    cropRect.origin.y = 0
    //
    // e.g., W = 2448, H = 2560 pW = 320, pH = 320 (square)
    //
    // ELSE:
    //    1. cW = H
    //    2. pW / pH = cH / cW
    //    => pW / pH = cH / H
    //    => cH = H * pW / pH
    //
    //    cropRect.origin.x = 0
    //    cropRect.origin.y = (W - cH) / 2
    //
    // e.g., W = 2448, H = 3264 pW = 320, pH = 568 (4" full screen)
    //
    let IMAGE_SIZE: CGSize = capturedPhotoImage.size
    let IMAGE_RATIO: CGFloat = IMAGE_SIZE.width / IMAGE_SIZE.height
    let fullscreenRatio: CGFloat = fullscreenViewSize.width / fullscreenViewSize.height

    KYIPLog("# Start cropping source image to camera capture view size in ratio ...")
    var fullscreenImageSize: CGSize
    var croppedSourceImageSizeInHalf: CGSize
    var scale: CGFloat

    // Scaled image to full fill screen, image's width cropped (generally, for all devices).
    if IMAGE_RATIO >= fullscreenRatio {
      KYIPLog("# Scaled image to full fill screen, image's WIDTH cropped.")
      fullscreenImageSize = CGSize(width: IMAGE_SIZE.height * fullscreenRatio, height: IMAGE_SIZE.height)
      croppedSourceImageSizeInHalf = CGSize(width: (IMAGE_SIZE.width - fullscreenImageSize.width) / 2, height: 0)
      scale = fullscreenImageSize.height / fullscreenViewSize.height
    }
    // Scaled image to full fill screen, image's height cropped.
    else {
      KYIPLog("# Scaled image to full fill screen, image's HEIGHT cropped.")
      fullscreenImageSize = CGSize(width: IMAGE_SIZE.width, height: IMAGE_SIZE.width / fullscreenRatio)
      croppedSourceImageSizeInHalf = CGSize(width: 0, height: (IMAGE_SIZE.height - fullscreenImageSize.height) / 2)
      scale = fullscreenImageSize.width / fullscreenViewSize.width
    }

    //
    // Note: `cameraCaptureViewFrameInRatio` is relative to fullscreen view, so we need to introduce
    //   `croppedSourceImageSizeInHalf`, which covers source image to fullscreen image's croppings.
    //
    // e.g., for iPhone 6S case:
    //
    // - Raw Image Size:         3024 * 4032
    // - Full Screen Image Size: 2268 * 4032 (image width is cropped here)
    //
    // So, croppedSourceImageSizeInHalf = {378, 0}
    //
    var cropRect = CGRect(
      x: croppedSourceImageSizeInHalf.height + cameraCaptureViewFrameInRatio.minY * scale,
      y: (IMAGE_SIZE.width - (croppedSourceImageSizeInHalf.width +
                              (cameraCaptureViewFrameInRatio.minX + cameraCaptureViewFrameInRatio.width) * scale)),
      width: cameraCaptureViewFrameInRatio.height * scale,
      height: cameraCaptureViewFrameInRatio.width * scale)

    KYIPLog("\n# Revising Crop Rect ...")
    cropRect = p_revisedFrame(cropRect, with: CGRect(x: 0, y: 0, width: IMAGE_SIZE.height, height: IMAGE_SIZE.width))

    //
    // Perform cropping in Core Graphics
    //
    // Obj-C:
    //   CGImageRef imageRef = CGImageCreateWithImageInRect(capturedPhotoImage.CGImage, cropRect)
    //   image = [UIImage imageWithCGImage:imageRef scale:capturedPhotoImage.scale orientation:orientation]
    //   CGImageRelease(imageRef)
    //
    var image: UIImage
    // REF: https://developer.apple.com/documentation/coregraphics/cgimage/1454683-cropping
    if let croppedCGImage = capturedPhotoImage.cgImage?.cropping(to: cropRect) {
      image = UIImage(cgImage: croppedCGImage, scale: capturedPhotoImage.scale, orientation: orientation)
    } else {
      image = capturedPhotoImage
    }
    KYIPLog("""
    - IMAGE_SIZE: \(IMAGE_SIZE)
    - fullscreenImageSize: \(fullscreenImageSize)
    - cameraCaptureViewFrameInRatio: \(cameraCaptureViewFrameInRatio)
    - cropRect: \(cropRect)
    - image.size: \(image.size)
    """)
    return image
  }

  // MARK: - Internal

#if DEBUG
  public static func debug_revisedFrame(
    _ frame: CGRect,
    with boundingFrame: CGRect
  ) -> CGRect {
    p_revisedFrame(frame, with: boundingFrame)
  }
#endif // END #if DEBUG

  /// Revise `frame` to fit with `boundingFrame`.
  ///
  /// - Parameters:
  ///   - frame: Original frame before revising.
  ///   - boundingFrame: Bounding frame.
  ///
  /// - Returns: Revised frame.
  ///
  static func p_revisedFrame(
    _ frame: CGRect,
    with boundingFrame: CGRect
  ) -> CGRect {

    var revisedFrameOrigin = CGPoint(x: floor(frame.minX), y: floor(frame.minY))
    if revisedFrameOrigin.x < boundingFrame.minX { revisedFrameOrigin.x = boundingFrame.minX }
    if revisedFrameOrigin.y < boundingFrame.minY { revisedFrameOrigin.y = boundingFrame.minY }

    var revisedFrameSize = CGSize(width: floor(frame.width), height: floor(frame.height))
    if revisedFrameOrigin.x + revisedFrameSize.width > boundingFrame.width {
      revisedFrameSize.width = boundingFrame.width - revisedFrameOrigin.x
    }

    if revisedFrameOrigin.y + revisedFrameSize.height > boundingFrame.height {
      revisedFrameSize.height = boundingFrame.height - revisedFrameOrigin.y
    }

    let revisedFrame = CGRect(origin: revisedFrameOrigin, size: revisedFrameSize)
    KYIPLog("""
  Revised frame: \(frame) to \(revisedFrame) w/
    - revisedFrameOrigin: \(revisedFrameOrigin)
    - revisedFrameSize: \(revisedFrameSize)
""")
    return revisedFrame
  }
}
#endif // END #if os(iOS)
