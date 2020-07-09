
import AsyncDisplayKit

final public class RandomCoreGraphicsNode: ASCellNode {
  static var randomColor: UIColor {
    let hue = CGFloat.random(in: 0.0...1.0)
    let saturation = CGFloat.random(in: 0.5...1.0)
    let brightness = CGFloat.random(in: 0.5...1.0)
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
  }
  
  public override class func draw(_ bounds: CGRect, withParameters parameters: Any?, isCancelled isCancelledBlock: () -> Bool, isRasterizing: Bool) {
    let colors = [Self.randomColor.cgColor, Self.randomColor.cgColor, Self.randomColor.cgColor] as CFArray
    let locations: [CGFloat] = [0.0, 1.0, CGFloat.random(in: 0.0...1.0)]
    
    let ctx = UIGraphicsGetCurrentContext()
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard
      let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
      else { return }
    
    ctx?.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: bounds.size.width, y: bounds.size.height), options: [])
  }
}
