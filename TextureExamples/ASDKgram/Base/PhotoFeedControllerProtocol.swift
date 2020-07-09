
import UIKit

public protocol PhotoFeedControllerProtocol: class {
  var tableView: UITableView? { get }
  
  func resetAllData()
}
