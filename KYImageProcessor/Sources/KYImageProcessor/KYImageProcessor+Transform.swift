//
//  KYImageProcessor+Transform.swift
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

  /// Transform an image to one with the expected dimensions.
  ///
  /// - Parameters:
  ///   - image: Raw image.
  ///   - transform: The transform applied to the image view, which is relative to the center of its bounds.
  ///   - currentImageViewFrame: Current image view's frame (related transform applied)
  ///   - productionImageSize: Expected production image size as final render canvas size.
  ///   - scale: Scale value from canvasViewSize to fullscreenImageSize.
  ///   - canvasBackgroundColor: Canvas background color.
  ///
  /// - Returns: Transformed image.
  ///
  public static func transformImage( // swiftlint:disable:this function_body_length function_parameter_count
    _ image: UIImage,
    with transform: CGAffineTransform,
    currentImageViewFrame: CGRect,
    productionImageSize: CGSize,
    scale: CGFloat,
    canvasBackgroundColor: UIColor?
  ) -> UIImage {

    let contextRect = CGRect(origin: .zero, size: productionImageSize)
    let contextImageRect = CGRect(origin: .zero, size: image.size)

    var imageViewFrameRelativeToContext: CGRect = currentImageViewFrame
    // var imageViewFrameRelativeToContext: CGRect = CGRectApplyAffineTransform(_imageView.frame, CGAffineTransformRotate(CGAffineTransformIdentity, rotate))
    imageViewFrameRelativeToContext.origin.x    *= scale
    imageViewFrameRelativeToContext.origin.y    *= scale
    imageViewFrameRelativeToContext.size.width  *= scale
    imageViewFrameRelativeToContext.size.height *= scale
    KYIPLog("contextRect: \(contextRect), imageViewFrameRelativeToContext: \(imageViewFrameRelativeToContext)")

    UIGraphicsBeginImageContextWithOptions(contextRect.size, true, 1)
    guard let context: CGContext = UIGraphicsGetCurrentContext() else {
      UIGraphicsEndImageContext()
      return image
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
      KYIPLog("\n  - imageScale: \(imageScale)\n  - imageRotate: \(imageRotate)")

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
      image.draw(in: contextImageRect)
    }
#else
    image.draw(in: contextImageRect)
#endif // END #if DEBUG

    // Restore context before transformation modification (context's coordinate system).
    context.restoreGState()
    // Generate a new image from current context.
    let transformImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return transformImage ?? image
  }

  // MARK: - Private

#if DEBUG
  public static func debug_offsetFromBoundingAreaAfterImageRotated(
    angle: CGFloat,
    imageSize: CGSize
  ) -> CGPoint {
    _offsetFromBoundingAreaAfterImageRotated(angle: angle, imageSize: imageSize)
  }
#endif // END #if DEBUG

  /// Obtain the offset of the original boundary area of the image after rotating a certain angle.
  ///
  /// The image is rotated with the top-left corner as the center, after rotation it will exceed
  ///   its bounding area and it needs to be moved backwards to ensure that the top and left lines
  ///   of the original bounding area match the bounding box of the rotated image.
  ///
  /// - Parameters:
  ///   - angle: The angle by which the image has been rotated (in radian, -M_PI <= angle <= M_PI).
  ///   - imageSize: The image size.
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
#endif // END #if os(iOS)
