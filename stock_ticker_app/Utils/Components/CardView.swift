
import Foundation
import UIKit

@IBDesignable // to show in storyBoard
class CardView: UIView {
    
    @IBInspectable var shadowCornerRadius : CGFloat = 2
    @IBInspectable var shadowOffsetWidth : Int = 0
    @IBInspectable var shadowOffsetHeight : Int = 0
    @IBInspectable var showColor : UIColor? = UIColor.black
    @IBInspectable var shadowOpacity : Float = 0.5
    @IBInspectable var borderWidth :  CGFloat = 0.0
    @IBInspectable var borderColor :  UIColor? = UIColor.black
    @IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var isCircle : Bool = false
    
    override func layoutSubviews() {

        layer.cornerRadius = isCircle ? frame.size.height / 2 : cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowCornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = showColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
