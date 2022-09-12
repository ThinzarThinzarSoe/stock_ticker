
import UIKit

extension UIFont {
    
    public enum Poppins: String {
        
        case Regular = "-Regular"
        case Italic = "-Italic"
        case Hairline = "-Hairline"
        case HairlineItalic = "-HairlineItalic"
        case Medium = "-Medium"
        case MediumItalic = "-MediumItalic"
        case Light = "-Light"
        case LightItalic = "-LightItalic"
        case Bold = "-Bold"
        case BoldItalic = "-BoldItalic"
        case SemiBold = "-SemiBold"
        case SemiBoldItalic = "-SemiBoldItalic"
        case ExtraBold = "-ExtraBold"
        case ExtraBoldItalic = "-ExtraBoldItalic"
        case Black = "-Black"
        case BlackItalic = "-BlackItalic"
        case Thin = "-Thin"
        case ThinItalic = "-ThinItalic"
        
        public func font( size: CGFloat, autoAjust: Bool = true) -> UIFont {
            return UIFont.screenAdjustedAppFont(name: "Poppins\(self.rawValue)", size: size, autoAjust: autoAjust)
        }
    }
    
    class func screenAdjustedAppFont(name: String, size: CGFloat, autoAjust : Bool) -> UIFont {
        
        if !autoAjust { return UIFont(name: name, size: size)! }
        
        /* 1.4 ratio font for tablet ipad sizes**/
        if iOSDeviceSizes.tabletSize.getBool() {
            return UIFont(name: name, size: size * 1.4)!
        }else if iOSDeviceSizes.plusSize.getBool() {
            /* 1.2 ratio font for iphone plus sizes**/
            return UIFont(name: name, size: size * 1.2)!
        }else if iOSDeviceSizes.miniSize.getBool() {
            /* 0.9 ratio font for iphone SE and mini sizes**/
            return UIFont(name: name, size: size * 0.9)!
        }
        
        return UIFont(name: name, size: size)!
    }
}
