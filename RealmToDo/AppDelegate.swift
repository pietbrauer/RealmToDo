import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    
    let viewController = ViewController()
    let navController = UINavigationController(rootViewController: viewController)
    
    window?.rootViewController = navController
    window?.makeKeyAndVisible()
    return true
  }
}

