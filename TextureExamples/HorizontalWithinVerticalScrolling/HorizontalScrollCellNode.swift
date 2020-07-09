
import AsyncDisplayKit

final public class HorizontalScrollCellNode: ASCellNode {
  private enum Constants {
    static let outerPadding: CGFloat = 16
    static let innerPadding: CGFloat = 10
  }
  
  private let collectionNode: ASCollectionNode
  private let divider = ASDisplayNode()
  private var elementSize: CGSize = .zero
  
  public override func layout() {
    super.layout()
    
    collectionNode.contentInset = UIEdgeInsets(top: 0,
                                               left: Constants.outerPadding,
                                               bottom: 0,
                                               right: Constants.outerPadding)
    
    // Manually layout the divider.
    let pixeHeight = 1.0 / UIScreen.main.scale
    divider.frame = CGRect(x: 0, y: 0, width: calculatedSize.width, height: pixeHeight)
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let collectionNodeSize = CGSize(width: constrainedSize.max.width, height: elementSize.height)
    collectionNode.style.preferredSize = collectionNodeSize
    
    return ASInsetLayoutSpec(insets: UIEdgeInsets(top: Constants.outerPadding,
                                                  left: 0,
                                                  bottom: Constants.outerPadding,
                                                  right: 0),
                             child: collectionNode)
  }
  
  public init(element size: CGSize) {
    elementSize = size
    
    // the containing table uses -nodeForRowAtIndexPath (rather than -nodeBlockForRowAtIndexPath),
    // so this init method will always be run on the main thread (thus it is safe to do UIKit things).
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.itemSize = elementSize
    flowLayout.minimumInteritemSpacing = Constants.innerPadding
    
    collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
    
    super.init()
    
    collectionNode.delegate = self
    collectionNode.dataSource = self
    addSubnode(collectionNode)
    
    // hairline cell separator
    divider.backgroundColor = .lightGray
    addSubnode(divider)
  }
}

extension HorizontalScrollCellNode: ASCollectionDataSource {
  public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  public func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    return { [elementSize] in
      let elementNode = RandomCoreGraphicsNode()
      elementNode.style.preferredSize = elementSize
      return elementNode
    }
  }
}

extension HorizontalScrollCellNode: ASCollectionDelegate {
  
}
