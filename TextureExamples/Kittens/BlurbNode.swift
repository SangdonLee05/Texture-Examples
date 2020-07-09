
import AsyncDisplayKit

final public class BlurbNode: ASCellNode {
  private enum Constants {
    static let textPadding: CGFloat = 10
    static let linkAttributeName: NSAttributedString.Key = NSAttributedString.Key("PlaceKittenNodeLinkAttributeName")
  }
  
  private let textNode = ASTextNode()
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let centerSpec = ASCenterLayoutSpec()
    centerSpec.centeringOptions = .X
    centerSpec.sizingOptions = .minimumY
    centerSpec.child = textNode
    
    let padding = UIEdgeInsets(top: Constants.textPadding,
                               left: Constants.textPadding,
                               bottom: Constants.textPadding,
                               right: Constants.textPadding)
    return ASInsetLayoutSpec(insets: padding, child: centerSpec)
  }
  
  public override func didLoad() {
    layer.as_allowsHighlightDrawing = true
    
    super.didLoad()
  }
  
  public override init() {
    super.init()
    
    // configure the node to support tappable links
    textNode.delegate = self
    textNode.isUserInteractionEnabled = true
    textNode.linkAttributeNames = [Constants.linkAttributeName.rawValue]
    
    // generate an attributed string using the custom link attribute specified above
    let linkAttributtes: [NSAttributedString.Key: Any] = [
      Constants.linkAttributeName: URL(string: "http://placekitten.com/")!,
      .foregroundColor: UIColor.gray,
      .underlineStyle: NSUnderlineStyle.single.rawValue | NSUnderlineStyle.patternDot.rawValue
    ]
    
    let blurb: NSString = "kittens courtesy placekitten.com \u{0001F638}"
    let string = NSMutableAttributedString(string: blurb as String)
    string.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Light", size: 16)!, range: NSMakeRange(0, blurb.length))
    string.addAttributes(linkAttributtes, range: blurb.range(of: "placekitten.com"))
    textNode.attributedText = string
    
    // add it as a subnode, and we're done
    addSubnode(textNode)
  }
}

//----------------------
// MARK:- ASTextNodeDelegate
//----------------------

extension BlurbNode: ASTextNodeDelegate {
  public func textNode(_ textNode: ASTextNode!, shouldHighlightLinkAttribute attribute: String!, value: Any!, at point: CGPoint) -> Bool {
    // opt into link highlighting -- tap and hold the link to try it!  must enable highlighting on a layer, see -didLoad
    return true
  }
  
  public func textNode(_ textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
    // the node tapped a link, open it
    guard let url = value as? URL else { return }
    
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
