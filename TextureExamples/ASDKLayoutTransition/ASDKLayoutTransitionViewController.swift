
import AsyncDisplayKit

final public class ASDKLayoutTransitionViewController: ASViewController<ASDisplayNode> {
  
  private let transitionNode = TransitionNode()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    transitionNode.backgroundColor = .gray
    
    node.addSubnode(transitionNode)
    
    title = "Layout Transition"
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isTranslucent = false
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    navigationController?.navigationBar.isTranslucent = true
    
    super.viewWillDisappear(animated)
  }
  
  public init() {
    super.init(node: transitionNode)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
