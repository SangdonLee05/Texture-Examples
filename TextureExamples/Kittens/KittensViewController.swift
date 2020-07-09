
import AsyncDisplayKit

final public class KittensViewController: ASViewController<ASDisplayNode> {
  private enum Constants {
    static let litterSize: Int = 20
    static let litterBatchSize: Int = 10
    static let maxLitterSize: Int = 100
  }
  
  private let tableNode = ASTableNode(style: .plain)
  private let blurbNodeIndexPath: NSIndexPath = NSIndexPath(item: 0, section: 0)
  private lazy var kittenDataSource: [CGSize] = createLitterWithSize(litterSize: Constants.litterSize)
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    tableNode.view.separatorStyle = .none
    node.addSubnode(tableNode)
  }
  
  public init() {
    super.init(node: tableNode)
    
    tableNode.dataSource = self
    tableNode.delegate = self
    
    title = "Kittens"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditingMode))
  }
  
  public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//----------------------
// MARK:- Private Methods
//----------------------

private extension KittensViewController {
  func createLitterWithSize(litterSize: Int) -> [CGSize] {
    return (0..<litterSize).map { _ -> CGSize in
      let deltaX = Int.random(in: 0..<10) - 5
      let deltaY = Int.random(in: 0..<10) - 5
      
      return CGSize(width: 350 + 2 * deltaX, height: 350 + 4 * deltaY)
    }
  }
  
  @objc func toggleEditingMode() {
    tableNode.view.setEditing(!tableNode.view.isEditing, animated: true)
  }
}

//----------------------
// MARK:- ASTableDataSource
//----------------------

extension KittensViewController: ASTableDataSource {
  public func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return kittenDataSource.count + 1
  }
  
  public func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    // special-case the first row
    if blurbNodeIndexPath.compare(indexPath) == .orderedSame {
      return {
        return BlurbNode()
      }
    }
    
    let size = kittenDataSource[indexPath.row - 1]
    return {
      return KittenNode(of: size)
    }
  }
  
  public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return blurbNodeIndexPath.compare(indexPath) != .orderedSame
  }
  
  public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      kittenDataSource.remove(at: indexPath.row - 1)
      tableNode.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}

//----------------------
// MARK:- ASTableDelegate
//----------------------

extension KittensViewController: ASTableDelegate {
  public func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    tableNode.deselectRow(at: indexPath, animated: true)
    
    // Assume only kitten nodes are selectable (see -tableNode:shouldHighlightRowAtIndexPath:).
    guard let node = tableNode.nodeForRow(at: indexPath) as? KittenNode else { return }
    node.toggleImageEnlargement()
  }
  
  public func tableNode(_ tableNode: ASTableNode, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    // Enable selection for kitten nodes
    return blurbNodeIndexPath.compare(indexPath) != .orderedSame
  }
  
  public func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      // populate a new array of random-sized kittens
      let moarKittens = self.createLitterWithSize(litterSize: Constants.litterBatchSize)
      
      // find number of kittens in the data source and create their indexPaths
      let existingRows = self.kittenDataSource.count + 1
      
      let indexPaths = (0..<moarKittens.count).map { (index) -> IndexPath in
        return IndexPath(row: existingRows + index, section: 0)
      }
      
      self.kittenDataSource.append(contentsOf: moarKittens)
      self.tableNode.insertRows(at: indexPaths, with: .fade)
      
      context.completeBatchFetching(true)
    }
  }
  
  public func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
    return kittenDataSource.count < Constants.maxLitterSize
  }
}
