
import AsyncDisplayKit

final public class TransitionNode: ASDisplayNode {
  
  private let buttonNode = ASButtonNode()
  private let textNodeOne = ASTextNode()
  private let textNodeTwo = ASTextNode()
  
  private var enabled: Bool = false
  
  public override func didLoad() {
    super.didLoad()
    
    buttonNode.addTarget(self, action: #selector(buttonPressed), forControlEvents: .touchUpInside)
    backgroundColor = .white
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let nextTextNode = enabled ? textNodeTwo : textNodeOne
    nextTextNode.style.flexGrow = 1.0
    nextTextNode.style.flexShrink = 1.0
    
    let horizontalStackLayout = ASStackLayoutSpec.horizontal()
    horizontalStackLayout.children = [nextTextNode]
    
    buttonNode.style.alignSelf = .center
    
    let verticalStackLayout = ASStackLayoutSpec.vertical()
    verticalStackLayout.spacing = 10.0
    verticalStackLayout.children = [horizontalStackLayout, buttonNode]
    
    return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 15,
                                                       left: 15,
                                                       bottom: 15,
                                                       right: 15),
                                  child: verticalStackLayout)
  }
  
  public override func animateLayoutTransition(_ context: ASContextTransitioning) {
    guard
      let fromNode = context.removedSubnodes().first,
      let toNode = context.insertedSubnodes().first,
      let buttonNode = context.subnodes(forKey: ASTransitionContextToLayoutKey).filter({ $0 is ASButtonNode }).first
      else { return }
    
    var toNodeFrame = context.finalFrame(for: toNode)
    toNodeFrame.origin.x += enabled ? toNodeFrame.size.width : -toNodeFrame.size.width
    toNode.frame = toNodeFrame
    toNode.alpha = 0.0
    
    var fromNodeFrame = fromNode.frame
    fromNodeFrame.origin.x += enabled ? -fromNodeFrame.size.width : fromNodeFrame.size.width
    
    UIView.animate(withDuration: defaultLayoutTransitionDuration,
                   animations: {
                    toNode.frame = context.finalFrame(for: toNode)
                    toNode.alpha = 1.0
                    
                    fromNode.frame = fromNodeFrame
                    fromNode.alpha = 0.0
                    
                    let fromSize = context.layout(forKey: ASTransitionContextFromLayoutKey)?.size ?? .zero
                    let toSize = context.layout(forKey: ASTransitionContextFromLayoutKey)?.size ?? .zero
                    let isResized = fromSize.equalTo(toSize) == false
                    if isResized {
                      let position = self.frame.origin
                      self.frame = CGRect(x: position.x, y: position.y, width: toSize.width, height: toSize.height)
                    }
                    
                    buttonNode.frame = context.finalFrame(for: buttonNode)
    }) { (isFinished) in
      context.completeTransition(isFinished)
    }
  }
  
  public override init() {
    super.init()
    
    automaticallyManagesSubnodes = true
    
    // Define the layout transition duration for the default transition
    defaultLayoutTransitionDuration = 1.0
    
    textNodeOne.attributedText = NSAttributedString(string: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled")
    
    textNodeTwo.attributedText = NSAttributedString(string: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.")
    
    // Setup button
    let buttonTitle = "Start Layout Transition"
    let buttonFont = UIFont.systemFont(ofSize: 16)
    let buttonColor = UIColor.blue
    
    buttonNode.setTitle(buttonTitle, with: buttonFont, with: buttonColor, for: .normal)
    buttonNode.setTitle(buttonTitle, with: buttonFont, with: buttonColor.withAlphaComponent(0.5), for: .highlighted)
    
    // Some debug colors
    textNodeOne.backgroundColor = .orange
    textNodeTwo.backgroundColor = .green
    
    addSubnode(buttonNode)
    addSubnode(textNodeOne)
    addSubnode(textNodeTwo)
  }
}

private extension TransitionNode {
  @objc func buttonPressed() {
    enabled.toggle()
    
    transitionLayout(withAnimation: true,
                     shouldMeasureAsync: false,
                     measurementCompletion: nil)
  }
}
