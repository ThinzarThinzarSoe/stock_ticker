
import UIKit

extension UIImageView {
    //MARK:- BlurEffect
    func setupBlurEffect (style : UIBlurEffect.Style = .systemThinMaterialDark , alpha : CGFloat = 0.7) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = alpha
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addSubview(blurEffectView)
    }
}
