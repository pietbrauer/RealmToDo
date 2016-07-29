import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()

        let viewController = ViewController(nibName: nil, bundle: nil)
        let navController = UINavigationController(rootViewController: viewController)

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }
}

