
import AsyncDisplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    let mainViewController = MainViewController()
    mainViewController.viewModel = ExampleViewModel()
    let navigationController = ASNavigationController(rootViewController: mainViewController)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    self.window = window
    
    return true
  }
}

