
import UIKit
import Kingfisher

class NewFeedHorizontalItemCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var titleView: CardView!
    @IBOutlet weak var imgNewFeed: RoundedUIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgTransparntBG: RoundedUIImageView!

    override func setupUI() {
        super.setupUI()
        layer.cornerRadius = 8
        titleView.clipsToBounds = true
        lblTitle.font = UIFont.Poppins.MediumItalic.font(size: 13)
        lblTitle.textColor = .darkGray
        imgNewFeed.clipsToBounds = true
        imgTransparntBG.clipsToBounds = true
        imgTransparntBG.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner, .layerMaxXMaxYCorner,.layerMinXMaxYCorner]
    }
    
    func setupCell(with articleVo: ArticleVO?) {
        if let articleVo = articleVo {
            lblTitle.text = articleVo.title ?? ""
            imgTransparntBG.setupBlurEffect(style: .extraLight, alpha: 0.9)
            imgNewFeed.kf.setImage(with: URL(string: articleVo.urlToImage ?? ""),placeholder: UIImage(named: "ic_placeholder"))
        }
    }
}

