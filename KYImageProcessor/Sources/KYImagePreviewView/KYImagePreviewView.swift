//
//  KYImagePreviewView.swift
//  KYImageProcessor
//
//  Created by Kjuly on 3/3/2018.
//  Copyright © 2018 Kaijie Yu. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit

public class KYImagePreviewView: UIView {

  /// Whether support rotation, default: YES.
  var isRotationEnabled: Bool

  let imageView: UIImageView

  // MARK: - Init

  public init(
    size: CGSize,
    image: UIImage?,
    defaultContentMode: UIView.ContentMode,
    backgroundColor: UIColor?
  ) {
    self.isRotationEnabled = true

    let imageView = UIImageView()
    imageView.contentMode = defaultContentMode
    self.imageView = imageView

    super.init(frame: CGRect(origin: .zero, size: size))

    self.clipsToBounds = true
    self.autoresizesSubviews = false
    self.isMultipleTouchEnabled = true
    self.backgroundColor = backgroundColor ?? .white

    addSubview(imageView)

    update(with: image)
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  // MARK: - Public

  public func image() -> UIImage? {
    return self.imageView.image
  }

  public func update(with image: UIImage?) {
    self.imageView.image = image

    if let imageSize = image?.size {
      self.imageView.frame = _imageViewFrame(with: imageSize, viewSizeAtMax: self.frame.size)
    }
  }

  public func resetImage() {
    self.imageView.transform = .identity
  }

  // MARK: - Private

  private func _imageViewFrame(with imageSize: CGSize, viewSizeAtMax: CGSize) -> CGRect {
    let imageViewRatio = KYImageViewRatio(w: imageSize.width, h: imageSize.height)
    let imageViewSize: CGSize = (self.imageView.contentMode == .scaleAspectFit
                                 ? imageViewRatio.scaleAspectFitSize(with: viewSizeAtMax)
                                 : imageViewRatio.scaleAspectFillSize(with: viewSizeAtMax))
    return CGRect(origin: CGPoint(x: (viewSizeAtMax.width - imageViewSize.width) / 2,
                                  y: (viewSizeAtMax.height - imageViewSize.height) / 2),
                  size: imageViewSize)
  }

  private func _middlePointOfPoints(_ pointOne: CGPoint, _ pointTwo: CGPoint) -> CGPoint {
    return CGPoint(x: (pointOne.x + pointTwo.x) / 2,
                   y: (pointOne.x + pointTwo.x) / 2)
  }

  private func _distanceBetweenPoints(_ pointOne: CGPoint, _ pointTwo: CGPoint) -> CGFloat {
    return sqrt(pow(pointOne.x - pointTwo.x, 2) + pow(pointOne.y - pointTwo.y, 2))
  }

  private func _angleBetweenPoints(_ pointOne: CGPoint, _ pointTwo: CGPoint) -> CGFloat {
    return atan2(pointOne.y - pointTwo.y, pointOne.x - pointTwo.x)
  }

  // MARK: - UIResponder
  /*
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
  }*/

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchesCount: Int = touches.count

    // Move
    if touchesCount == 1 {
      guard let touch = touches.first else {
        return
      }
      let currentTouchPoint: CGPoint = touch.location(in: self)
      let previousTouchPoint: CGPoint = touch.previousLocation(in: self)
      self.imageView.transform = CGAffineTransformConcat(
        self.imageView.transform,
        CGAffineTransformMakeTranslation(currentTouchPoint.x - previousTouchPoint.x,
                                         currentTouchPoint.y - previousTouchPoint.y))
    }
    // Move, Zoom, Rotation
    else if touchesCount == 2 {
      let touchesArray = Array(touches)
      guard
        let touchOne = touchesArray.first,
        let touchTwo = touchesArray.last
      else {
        return
      }

      let previousPointOfTouchOne: CGPoint = touchOne.previousLocation(in: self)
      let previousPointOfTouchTwo: CGPoint = touchTwo.previousLocation(in: self)

      let currentPointOfTouchOne: CGPoint = touchOne.location(in: self)
      let currentPointOfTouchTwo: CGPoint = touchTwo.location(in: self)

      // Move
      let middlePointOfPreviousTouchPoints: CGPoint = _middlePointOfPoints(previousPointOfTouchOne, previousPointOfTouchTwo)
      let middlePointOfCurrentTouchPoints: CGPoint = _middlePointOfPoints(currentPointOfTouchOne, currentPointOfTouchTwo)
      let deltaX: CGFloat = middlePointOfCurrentTouchPoints.x - middlePointOfPreviousTouchPoints.x
      let deltaY: CGFloat = middlePointOfCurrentTouchPoints.y - middlePointOfPreviousTouchPoints.y
      var transform: CGAffineTransform = CGAffineTransformConcat(self.imageView.transform, CGAffineTransformMakeTranslation(deltaX, deltaY))
      self.imageView.transform = transform

      // Zoom
      var distanceBetweenPreviousTouchPoints: CGFloat = _distanceBetweenPoints(previousPointOfTouchOne, previousPointOfTouchTwo)
      if distanceBetweenPreviousTouchPoints == 0 {
        distanceBetweenPreviousTouchPoints = 1
      }
      let scale: CGFloat = (_distanceBetweenPoints(currentPointOfTouchOne, currentPointOfTouchTwo)
                            / distanceBetweenPreviousTouchPoints)
      transform = CGAffineTransformScale(transform, scale, scale)
      self.imageView.transform = transform

      // Rotate if needed
      if self.isRotationEnabled {
        let angle: CGFloat = (_angleBetweenPoints(currentPointOfTouchOne, currentPointOfTouchTwo)
                              - _angleBetweenPoints(previousPointOfTouchOne, previousPointOfTouchTwo))
        transform = CGAffineTransformRotate(transform, angle)
        self.imageView.transform = transform
      }
    }
  }

  /*
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
  }

  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
  }*/
}
#endif
