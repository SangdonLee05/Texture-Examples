
import AsyncDisplayKit

protocol MainViewModelInterface {
  var itemCount: Int { get }
  
  func title(at index: Int) -> String
  func instance<T>(at index: Int) -> T
}

final public class MainViewController: ASViewController<ASTableNode> {
  
  private let tableNode = ASTableNode(style: .plain)
  
  internal var viewModel: MainViewModelInterface!
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    tableNode.view.separatorStyle = .singleLine
    node.addSubnode(tableNode)
  }
  
  public init() {
    super.init(node: tableNode)
    
    tableNode.dataSource = self
    tableNode.delegate = self
    
    title = "Example Lists"
  }
  
  public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension MainViewController: ASTableDelegate {
  public func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    tableNode.deselectRow(at: indexPath, animated: true)
    
    let viewController = (viewModel.instance(at: indexPath.row) as ASViewController.Type).init()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

extension MainViewController: ASTableDataSource {
  public func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return viewModel.itemCount
  }
  
  public func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    return { [unowned self] in
      let node = MainViewNode()
      node.text = self.viewModel.title(at: indexPath.row)
      return node
    }
  }
}
