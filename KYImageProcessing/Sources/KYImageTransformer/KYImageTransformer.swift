//
//  KYImageTransformer.swift
//  KYImageProcessing
//
//  Created by Kjuly on 24/10/2019.
//  Copyright © 2019 Kaijie Yu. All rights reserved.
//

import UIKit

public class KYImageTransformer {
#if DEBUG
  static let DEBUG_CROPPING_IMAGE_: Bool = false
#endif // END #if DEBUG

  // MARK: - Public

  /// Get the scale value from `sizeFrom` to `sizeTo`, will return the higher one
  ///   of `sizeTo.width / sizeFrom.width` & `sizeTo.height / sizeTo.height`.
  public static func scaleValue(from sizeFrom: CGSize, to sizeTo: CGSize) -> CGFloat {
    return max(sizeTo.width / sizeFrom.width, sizeTo.height / sizeFrom.height)
  }

  /// Generate raw photo image from capturered source image (unedited image that captured from camera).
  ///
  /// - Parameters:
  ///   - captureredSourceImage: Unedited image that captured from camera
  ///   - orientation: The orientation for the captured image
  ///   - fullscreenViewSize: Fullscreen view size of current device
  ///   - cameraCaptureViewFrameInRatio: Camera capture view frame in ratio (expected raw photo image size in ratio)
  ///
  /// - Returns: Raw photo image that cropped to size in ratio that expected.
  ///
  public static func rawPhotoImage(
    from captureredSourceImage: UIImage,
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
    let IMAGE_SIZE: CGSize = captureredSourceImage.size
    let IMAGE_RATIO: CGFloat = IMAGE_SIZE.width / IMAGE_SIZE.height
    let fullscreenRatio: CGFloat = fullscreenViewSize.width / fullscreenViewSize.height

    KYImageProcessingLog("# Start cropping source image to camera capture view size in ratio ...")
    var fullscreenImageSize: CGSize
    var croppedSourceImageSizeInHalf: CGSize
    var scale: CGFloat

    // Scaled image to full fill screen, image's width cropped (generally, for all devices).
    if IMAGE_RATIO >= fullscreenRatio {
      KYImageProcessingLog("# Scaled image to full fill screen, image's WIDTH cropped.")
      fullscreenImageSize = CGSize(width: IMAGE_SIZE.height * fullscreenRatio, height: IMAGE_SIZE.height)
      croppedSourceImageSizeInHalf = CGSize(width: (IMAGE_SIZE.width - fullscreenImageSize.width) / 2, height: 0)
      scale = fullscreenImageSize.height / fullscreenViewSize.height
    }
    // Scaled image to full fill screen, image's height cropped.
    else {
      KYImageProcessingLog("# Scaled image to full fill screen, image's HEIGHT cropped.")
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

    KYImageProcessingLog("\n# Revising Crop Rect ...")
    cropRect = _revisedFrame(cropRect, with: CGRect(x: 0, y: 0, width: IMAGE_SIZE.height, height: IMAGE_SIZE.width))

    //
    // Perform cropping in Core Graphics
    //
    // Obj-C:
    //   CGImageRef imageRef = CGImageCreateWithImageInRect(captureredSourceImage.CGImage, cropRect)
    //   rawPhotoImage = [UIImage imageWithCGImage:imageRef scale:captureredSourceImage.scale orientation:orientation]
    //   CGImageRelease(imageRef)
    //
    var rawPhotoImage: UIImage
    // REF: https://developer.apple.com/documentation/coregraphics/cgimage/1454683-cropping
    if let croppedCGImage = captureredSourceImage.cgImage?.cropping(to: cropRect) {
      rawPhotoImage = UIImage(cgImage: croppedCGImage, scale: captureredSourceImage.scale, orientation: orientation)
    } else {
      rawPhotoImage = captureredSourceImage
    }
    KYImageProcessingLog("\n  - IMAGE_SIZE: \(IMAGE_SIZE)\n  - fullscreenImageSize: \(fullscreenImageSize)\n  - cameraCaptureViewFrameInRatio: \(cameraCaptureViewFrameInRatio)\n  - cropRect: \(cropRect)\n  - rawPhotoImage.size: \(rawPhotoImage.size)")
    return rawPhotoImage
  }

  /// Callback when captured a photo image.
  ///
  /// - Parameters:
  ///   - rawPhotoImage: Raw photo image w/o any transformation
  ///   - transform: The transform applied to the image view, which relative to the center of its bounds
  ///   - currentImageViewFrame: Current image view's frame (related transform applied)
  ///   - productionImageSize: Production image size as the final rendered convas size
  ///   - scale: Scale value from canvasViewSize to fullscreenImageSize
  ///   - canvasBackgroundColor: Canvas background color
  ///
  /// - Returns: Transformed image.
  ///
  static func transformedImage( // swiftlint:disable:this function_body_length function_parameter_count
    from rawPhotoImage: UIImage,
    with transform: CGAffineTransform,
    currentImageViewFrame: CGRect,
    productionImageSize: CGSize,
    scale: CGFloat,
    canvasBackgroundColor: UIColor?
  ) -> UIImage {

    let contextRect = CGRect(origin: .zero, size: productionImageSize)
    let contextImageRect = CGRect(origin: .zero, size: rawPhotoImage.size)

    var imageViewFrameRelativeToContext: CGRect = currentImageViewFrame
    // var imageViewFrameRelativeToContext: CGRect = CGRectApplyAffineTransform(_imageView.frame, CGAffineTransformRotate(CGAffineTransformIdentity, rotate))
    imageViewFrameRelativeToContext.origin.x    *= scale
    imageViewFrameRelativeToContext.origin.y    *= scale
    imageViewFrameRelativeToContext.size.width  *= scale
    imageViewFrameRelativeToContext.size.height *= scale
    KYImageProcessingLog("contextRect: \(contextRect), imageViewFrameRelativeToContext: \(imageViewFrameRelativeToContext)")

    UIGraphicsBeginImageContextWithOptions(contextRect.size, true, 1)
    guard let context: CGContext = UIGraphicsGetCurrentContext() else {
      UIGraphicsEndImageContext()
      return rawPhotoImage
    }

    //
    // Fill context's background color w/ canvas' color.
    //
    if let canvasBackgroundColor {
      var red: CGFloat = 0
      var green: CGFloat = 0
      var blue: CGFloat = 0
      if canvasBackgroundColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
        context.setFillColor(red: red, green: green, blue: blue, alpha: 1)
      } else {
        context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
      }
    } else {
      context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    context.fill(contextRect)

    // Save context before any transformation modification (context's coordinate system).
    context.saveGState()

    //
    // Apply image transformation to context's coordinate system.
    //

    //
    // - Move
    //
    // By default the origin of context is the top-left (0, 0). That means any transformations
    //   we apply to the context will happen about that point. If we do a 90 degree clockwise
    //   rotation, the context will now be off screen.
    // To deal with this, we need to translate the context so that the rotation happens about
    //   the center of the context.
    //
    // REF:
    //   - https://teamtreehouse.com/community/saving-a-rotated-image-with-cgcontextrotatectm
    //   - https://stackoverflow.com/questions/16766111/rotate-image-using-cgcontextdrawimage
    //
    // ObjC:
    //   CGContextTranslateCTM(context, CGRectGetMinX(imageViewFrameRelativeToContext), CGRectGetMinY(imageViewFrameRelativeToContext))
    //
    context.translateBy(x: imageViewFrameRelativeToContext.minX,
                        y: imageViewFrameRelativeToContext.minY)
#if DEBUG
    if DEBUG_CROPPING_IMAGE_ {
      context.setFillColor(red: 0, green: 1, blue: 0, alpha: 1) // green
      context.fill(contextImageRect)
    }
#endif // END #if DEBUG

    //
    // Apply scale & rotate transformations only if it's not identity.
    //
    if !CGAffineTransformIsIdentity(transform) {
      //
      // REF:
      // - https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_affine/dq_affine.html#//apple_ref/doc/uid/TP30001066-CH204-CJBECIAD
      // - https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/HandlingImages/Images.html
      //
      // CGPoint imageOffset = CGPointMake(transform.tx, transform.ty)
      let imageScale: CGFloat  = sqrt(transform.a * transform.a + transform.c * transform.c)
      let imageRotate: CGFloat = CGFloat(atan2f(Float(transform.b), Float(transform.a)))
      KYImageProcessingLog("\n  - imageScale: \(imageScale)\n  - imageRotate: \(imageRotate)")

      // - Scale
      context.scaleBy(x: imageScale, y: imageScale)
#if DEBUG
      if DEBUG_CROPPING_IMAGE_ {
        context.setFillColor(red: 1, green: 1, blue: 0, alpha: 1) // yellow
        context.fill(contextImageRect)
      }
#endif // END #if DEBUG

      // - Rotate
      context.rotate(by: imageRotate)
#if DEBUG
      if DEBUG_CROPPING_IMAGE_ {
        context.setFillColor(red: 1, green: 0, blue: 0, alpha: 1) // red
        context.fill(contextImageRect)
      }
#endif // END #if DEBUG

      // - After rotated context, should mv it back to original image's bounding area.
      // Note:
      //   `offset` here is relative to rotated context coordinate system, and the rotation
      //   center is image's top-left corner.
      let offset: CGPoint = _offsetFromBoundingAreaAfterImageRotated(angle: imageRotate, imageSize: contextImageRect.size)
      context.translateBy(x: offset.x, y: offset.y)
    }

    //
    // Draw image
    //
#if DEBUG
    if DEBUG_CROPPING_IMAGE_ {
      context.setFillColor(red: 0, green: 0, blue: 1, alpha: 1) // blue
      context.fill(contextImageRect)
    } else {
      rawPhotoImage.draw(in: contextImageRect)
    }
#else
    rawPhotoImage.draw(in: contextImageRect)
#endif // END #if DEBUG

    // Restore context before transformation modification (context's coordinate system).
    context.restoreGState()
    // Generate a new image from current context.
    let transformedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return transformedImage ?? rawPhotoImage
  }

  /// Callback when captured a photo image.
  ///
  /// - Parameters:
  ///   - image: Image to crop
  ///   - cropFrame: Fullscreen image size as the final rendered convas size
  ///   - canvasFrame: Canvas frame
  ///   - scale: Scale value from canvasViewSize to fullscreenImageSize.
  ///
  /// - Returns: Transformed image.
  ///
  static func croppedImage(
    from image: UIImage,
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
    KYImageProcessingLog("\n# Revising Crop Rect ...")
    cropRect = _revisedFrame(cropRect, with: CGRect(origin: .zero, size: IMAGE_SIZE))

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

    KYImageProcessingLog("\n  - canvasFrame: \(canvasFrame)\n  - crop frame relative to canvas: \(CGRect(origin: cropOriginRelativeToCanvas, size: cropSize))\n  - IMAGE_SIZE: \(IMAGE_SIZE)\n  - cropRect: \(cropRect)\n  - croppedImage.size: \(croppedImage?.size ?? .zero)")

    return croppedImage ?? image
  }

  // MARK: - Private

#if DEBUG
  public static func revisedFrame(
    _ frame: CGRect,
    with boundingFrame: CGRect
  ) -> CGRect {
    _revisedFrame(frame, with: boundingFrame)
  }

  public static func offsetFromBoundingAreaAfterImageRotated(
    angle: CGFloat,
    imageSize: CGSize
  ) -> CGPoint {
    _offsetFromBoundingAreaAfterImageRotated(angle: angle, imageSize: imageSize)
  }
#endif // END #if DEBUG

  /// Revise `frame` to fit w/ `boundingFrame`.
  ///
  /// - Parameters:
  ///   - frame: Original frame before revising
  ///   - boundingFrame: Bounding frame
  ///
  /// - Returns: Revised frame.
  ///
  private static func _revisedFrame(
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
    KYImageProcessingLog("\n  Revised frame: \(frame) to \(revisedFrame) w/\n    - revisedFrameOrigin: \(revisedFrameOrigin)\n    - revisedFrameSize: \(revisedFrameSize)")

    return revisedFrame
  }

  /// Get the offset from image's original bounding area after rotated w/ an angle.
  ///
  /// Image rotates w/ its top-left corner as center, after rotation, it
  ///   will beyond it's bounding area, need to mv it back to make sure original bounding
  ///   area's top & left line matches rotated image's bounding frame.
  ///
  /// - Parameters:
  ///   - angle: The angle image rotated (in radian, -M_PI <= angle <= M_PI)
  ///   - imageSize: The image size
  ///
  /// - Returns: Offset point.
  ///
  private static func _offsetFromBoundingAreaAfterImageRotated(
    angle: CGFloat,
    imageSize: CGSize
  ) -> CGPoint {
    //
    // Note: `offset` here is relative to rotated context coordinate system, and the rotation
    //   center is image's top-left corner.
    //
    //      (-PI/2)
    //     III| IV
    //  PI ---|--- 0
    //     II | I
    //       PI/2
    //
    var offset: CGPoint
    let PI: CGFloat = Double.pi
    let PI_2: CGFloat = PI / 2
    // I
    if 0 <= angle && angle <= PI_2 {
      if 0 == angle {
        offset = .zero
      } else if PI_2 == angle {
        offset = CGPoint(x: 0, y: -imageSize.height)
      } else {
        let hypotenuse: CGFloat = imageSize.height * sin(angle)
        offset = CGPoint(x: hypotenuse * cos(angle),
                         y: -hypotenuse * sin(angle))
      }
    }
    // II
    else if PI_2 < angle && angle <= PI {
      if PI == angle {
        offset = CGPoint(x: -imageSize.width, y: -imageSize.height)
      } else {
        let adjustedAngle = PI - angle
        let hypotenuse: CGFloat = imageSize.width * cos(adjustedAngle)
        offset = CGPoint(x: -hypotenuse * cos(adjustedAngle),
                         y: -(hypotenuse * sin(adjustedAngle) + imageSize.height))
      }
    }
    // IV
    else if -PI_2 <= angle && angle < 0 {
      if -PI_2 == angle {
        offset = CGPoint(x: -imageSize.width, y: 0)
      } else {
        let adjustedAngle = PI_2 + angle
        let hypotenuse: CGFloat = imageSize.width * cos(adjustedAngle)
        offset = CGPoint(x: -hypotenuse * cos(adjustedAngle),
                         y: hypotenuse * sin(adjustedAngle))
      }
    }
    // III
    else {
      let adjustedAngle = PI + angle
      let hypotenuse: CGFloat = imageSize.height * cos(adjustedAngle)
      offset = CGPoint(x: -(hypotenuse * sin(adjustedAngle) + imageSize.width),
                       y: -hypotenuse * cos(adjustedAngle))
    }
    return offset
  }
}
