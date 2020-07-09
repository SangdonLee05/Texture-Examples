
import AsyncDisplayKit

final public class MainViewNode: ASCellNode {
  private let textNode = ASTextNode()
  
  public var text: String? {
    didSet {
      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14)
      ]
      textNode.attributedText = NSMutableAttributedString(string: text ?? "", attributes: attributes)
    }
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let centerSpec = ASCenterLayoutSpec()
    centerSpec.centeringOptions = .Y
    centerSpec.sizingOptions = .minimumXY
    centerSpec.child = textNode
    centerSpec.style.height = ASDimension(unit: .points, value: 40)
    
    return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10,
                                                  left: 10,
                                                  bottom: 10,
                                                  right: 10),
                             child: centerSpec)
  }
  
  public override init() {
    super.init()
    
    textNode.isUserInteractionEnabled = false
    addSubnode(textNode)
  }
}
