
import AsyncDisplayKit

final public class PhotoFeedBaseController: ASViewController<ASDisplayNode> {
  public var photoFeed: PhotoFeedModel?
  public var tableView: UITableView? { return nil }
  
  public init() {
    super.init(node: ASDisplayNode())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PhotoFeedBaseController: PhotoFeedControllerProtocol {
  public func resetAllData() {
    
  }
}
