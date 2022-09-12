

import UIKit
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachability: Reachability?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setRootViewController()
        return true
    }
    
    class func sharedAppDelegate() -> AppDelegate? {
            return UIApplication.shared.delegate as? AppDelegate
    }
}

extension AppDelegate {
    /*!
     * @discussion - to display home screen
     * @params - UIWindowScene
     * @return - void
     */
    private func setRootViewController(){
        let vc = HomeCollectionViewController.init()
        let rootVC = UINavigationController.init(rootViewController: vc)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}

 
