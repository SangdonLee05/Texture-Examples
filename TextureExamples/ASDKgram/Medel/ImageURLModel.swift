
import Foundation
import CoreGraphics

public struct ImageURLModel {
  static func imageParameter(forClosestImage size: CGSize) -> String {
    guard
      size.width == size.height
      else { return "" }
    
    let imageParameterID = Self.imageParameter(forSquareCropped: size)
    return "&image_size=\(imageParameterID)"
  }
  
  private static func imageParameter(forSquareCropped size: CGSize) -> Int {
    switch size.height {
    case let height where height <= 70: return 1
    case let height where height <= 100: return 100
    case let height where height <= 140: return 2
    case let height where height <= 200: return 200
    case let height where height <= 280: return 3
    case let height where height <= 400: return 400
    default: return 600
    }
  }
}
