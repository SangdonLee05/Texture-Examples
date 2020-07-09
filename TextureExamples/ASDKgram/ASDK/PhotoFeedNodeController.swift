
import AsyncDisplayKit

final public class PhotoFeedNodeController: ASViewController<ASTableNode> {
  private enum Constants {
    static let autoTailLoadingNumScreenfuls: CGFloat = 2.5
  }
  
  private let tableNode = ASTableNode(style: .plain)
  
  // -loadView is guaranteed to be called on the main thread and is the appropriate place to
  // set up an UIKit objects you may be using.
  public override func loadView() {
    super.loadView()
    
    // overriding default of 2.0
    tableNode.leadingScreensForBatching = Constants.autoTailLoadingNumScreenfuls
  }
  
  // -init is often called off the main thread in ASDK. Therefore it is imperative that no UIKit objects are accessed.
  // Examples of common errors include accessing the node’s view or creating a gesture recognizer.
  public init() {
    super.init(node: tableNode)
    
    tableNode.dataSource = self
    tableNode.delegate = self
    
    title = "ASDK"
    navigationController?.isNavigationBarHidden = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

//----------------------
// MARK: - Public Methods
//----------------------

public extension PhotoFeedNodeController {
  func loadPageWithContext(context: ASBatchContext) {
    
  }
}

//----------------------
// MARK: - ASTableDelegate
//----------------------

extension PhotoFeedNodeController: ASTableDelegate {
  
}

//----------------------
// MARK: - ASTableDataSource
//----------------------

extension PhotoFeedNodeController: ASTableDataSource {
  
}
