
import Foundation
import TextureExamples

final public class ExampleViewModel: NSObject, MainViewModelInterface {
  public var itemCount: Int { items.count }
  
  // Setup List Data
  private var items: [ExampleData] = [
    ExampleData(title: "Kittens", instance: KittensViewController.self),
    ExampleData(title: "HorizontalWithinVerticalScrolling", instance: HorizontalWithinVerticalScrollingViewController.self),
    ExampleData(title: "ASDKLayoutTransitionViewController", instance: ASDKLayoutTransitionViewController.self),
  ]
  
  public func title(at index: Int) -> String {
    return items[index].title
  }
  
  public func instance<T>(at index: Int) -> T {
    return items[index].instance as! T
  }
  
  public override init() {
    super.init()
  }
}
