
import AsyncDisplayKit

final public class KittenNode: ASCellNode {
  
  static let placeholders: [String] = [
    "Kitty ipsum dolor sit amet, purr sleep on your face lay down in your way biting, sniff tincidunt a etiam fluffy fur judging you stuck in a tree kittens.",
    "Lick tincidunt a biting eat the grass, egestas enim ut lick leap puking climb the curtains lick.",
    "Lick quis nunc toss the mousie vel, tortor pellentesque sunbathe orci turpis non tail flick suscipit sleep in the sink.",
    "Orci turpis litter box et stuck in a tree, egestas ac tempus et aliquam elit.",
    "Hairball iaculis dolor dolor neque, nibh adipiscing vehicula egestas dolor aliquam.",
    "Sunbathe fluffy fur tortor faucibus pharetra jump, enim jump on the table I don't like that food catnip toss the mousie scratched.",
    "Quis nunc nam sleep in the sink quis nunc purr faucibus, chase the red dot consectetur bat sagittis.",
    "Lick tail flick jump on the table stretching purr amet, rhoncus scratched jump on the table run.",
    "Suspendisse aliquam vulputate feed me sleep on your keyboard, rip the couch faucibus sleep on your keyboard tristique give me fish dolor.",
    "Rip the couch hiss attack your ankles biting pellentesque puking, enim suspendisse enim mauris a.",
    "Sollicitudin iaculis vestibulum toss the mousie biting attack your ankles, puking nunc jump adipiscing in viverra.",
    "Nam zzz amet neque, bat tincidunt a iaculis sniff hiss bibendum leap nibh.",
    "Chase the red dot enim puking chuf, tristique et egestas sniff sollicitudin pharetra enim ut mauris a.",
    "Sagittis scratched et lick, hairball leap attack adipiscing catnip tail flick iaculis lick.",
    "Neque neque sleep in the sink neque sleep on your face, climb the curtains chuf tail flick sniff tortor non.",
    "Ac etiam kittens claw toss the mousie jump, pellentesque rhoncus litter box give me fish adipiscing mauris a.",
    "Pharetra egestas sunbathe faucibus ac fluffy fur, hiss feed me give me fish accumsan.",
    "Tortor leap tristique accumsan rutrum sleep in the sink, amet sollicitudin adipiscing dolor chase the red dot.",
    "Knock over the lamp pharetra vehicula sleep on your face rhoncus, jump elit cras nec quis quis nunc nam.",
    "Sollicitudin feed me et ac in viverra catnip, nunc eat I don't like that food iaculis give me fish.",
  ]
  
  private enum Constants {
    static let imageSize: CGFloat = 80.0
    static let outerPadding: CGFloat = 16.0
    static let innerPadding: CGFloat = 10.0
    static let imageURLPath: String = "https://placekitten.com"
  }
  
  private var kittenSize: CGSize
  private let imageNode = ASNetworkImageNode()
  private let textNode = ASTextNode()
  private let divider = ASDisplayNode()
  
  private var isImageEnlarged: Bool = false
  private var swappedTextAndImage: Bool = false
  
  public override var isSelected: Bool {
    didSet {
      updateBackgroundColor()
    }
  }
  
  public override var isHighlighted: Bool {
    didSet {
      updateBackgroundColor()
    }
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    // Set an intrinsic size for the image node
    let imageSize =
      isImageEnlarged ?
        CGSize(width: 2.0 * Constants.imageSize, height: 2.0 * Constants.imageSize)
        : CGSize(width: Constants.imageSize, height: Constants.imageSize)
    
    // Shrink the text node in case the image + text gonna be too wide
    imageNode.style.preferredSize = imageSize
    textNode.style.flexShrink = 1.0
    
    // Configure stack
    let stackLayoutSpec = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: Constants.innerPadding,
                                            justifyContent: .start,
                                            alignItems: .start,
                                            children: swappedTextAndImage ? [textNode, imageNode] : [imageNode, textNode])
    
    // Add inset
    return ASInsetLayoutSpec(insets: UIEdgeInsets(top: Constants.outerPadding,
                                                  left: Constants.outerPadding,
                                                  bottom: Constants.outerPadding,
                                                  right: Constants.outerPadding),
                             child: stackLayoutSpec)
  }
  
  public override func layout() {
    super.layout()
    
    // Manually layout the divider.
    let pixelHeight = 1.0 / UIScreen.main.scale
    divider.frame = CGRect(x: 0, y: 0, width: calculatedSize.width, height: pixelHeight)
  }
  
  public init(of kittenSize: CGSize) {
    self.kittenSize = kittenSize
    
    super.init()
    
    // kitten image, with a solid background colour serving as placeholder
    let urlPath = [Constants.imageURLPath, "\(Int(round(kittenSize.width)))", "\(Int(round(kittenSize.height)))"].joined(separator: "/")
    imageNode.url = URL(string: urlPath)
    imageNode.placeholderFadeDuration = 0.5
    imageNode.placeholderColor = ASDisplayNodeDefaultPlaceholderColor()
    imageNode.addTarget(self, action: #selector(toggleNodesSwap), forControlEvents: .touchUpInside)
    addSubnode(imageNode)
    
    // lorem ipsum text, plus some nice styling
    textNode.shadowColor = UIColor.black.cgColor
    textNode.shadowRadius = 3
    textNode.shadowOffset = CGSize(width: -2, height: -2)
    textNode.shadowOpacity = 0.3
    
    if textNode.usingExperiment {
      textNode.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1)
    }
    else {
      textNode.backgroundColor = UIColor(red: 1, green: 0.9, blue: 0.9, alpha: 1)
    }
    
    textNode.maximumNumberOfLines = 2
    textNode.truncationAttributedText = NSAttributedString(string: "…")
    textNode.additionalTruncationMessage = NSAttributedString(string: "More")
    textNode.attributedText = NSAttributedString(string: kittyIpsum(), attributes: textStyle())
    addSubnode(textNode)
    
    // hairline cell separator
    divider.backgroundColor = .lightGray
    addSubnode(divider)
  }
}

//----------------------
// MARK:- Public Methods
//----------------------

extension KittenNode {
  func toggleImageEnlargement() {
    isImageEnlarged.toggle()
    setNeedsLayout()
  }
}

//----------------------
// MARK:- Private Methods
//----------------------

private extension KittenNode {
  @objc func toggleNodesSwap() {
    swappedTextAndImage.toggle()
    
    UIView.animate(withDuration: 0.15,
                   animations: {
                    self.alpha = 0
    }) { (isFinished) in
      self.setNeedsLayout()
      self.view.layoutIfNeeded()
      
      UIView.animate(withDuration: 0.15) {
        self.alpha = 1
      }
    }
  }
  
  func kittyIpsum() -> String {
    let placeholders = Self.placeholders
    let ipsumCount = placeholders.count
    let location = Int.random(in: 0..<ipsumCount)
    let length = Int.random(in: 0..<(ipsumCount - location))
    
    var string = placeholders[location]
    for index in stride(from: location + 1, to: location + length, by: 1) {
      string.append(index.isMultiple(of: 2) ? "\n" : "  ")
      string.append(placeholders[Int(index)])
    }
    
    return string
  }
  
  func textStyle() -> [NSAttributedString.Key: Any] {
    guard
      let font = UIFont(name: "HelveticaNeue", size: 12.0),
      let style = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
      else { return [:] }
    
    style.paragraphSpacing = 0.5 * font.lineHeight
    style.hyphenationFactor = 1.0
    
    return [
      .font: font,
      .paragraphStyle: style,
      .kern: 0.5
    ]
  }
  
  func updateBackgroundColor() {
    if isHighlighted {
      backgroundColor = .lightGray
    }
    else if isSelected {
      backgroundColor = .blue
    }
    else {
      backgroundColor = .white
    }
  }
}
