
import UIKit

class AppScreens {
    
    static var shared = AppScreens()
    
    var startAnimationView : UIView?
    var currentVC : UIViewController?
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
}
