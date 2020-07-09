
import AsyncDisplayKit

final public class HorizontalWithinVerticalScrollingViewController: ASViewController<ASDisplayNode> {
  
  private let tableNode = ASTableNode()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    tableNode.view.separatorStyle = .none
  }
  
  public init() {
    super.init(node: tableNode)
    
    tableNode.delegate = self
    tableNode.dataSource = self
    
    title = "Horizontal Scrolling Gradients"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo,
                                                        target: self,
                                                        action: #selector(reloadEverything))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension HorizontalWithinVerticalScrollingViewController {
  @objc func reloadEverything() {
    tableNode.reloadData()
  }
}

extension HorizontalWithinVerticalScrollingViewController: ASTableDelegate {
  
}

extension HorizontalWithinVerticalScrollingViewController: ASTableDataSource {
  public func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  public func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    return {
      return HorizontalScrollCellNode(element: CGSize(width: 100, height: 100))
    }
  }
}
