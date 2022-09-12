
import UIKit
import Kingfisher

class NewFeedItemCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var imgNewFeed: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func setupUI() {
        super.setupUI()
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor("#EDEDED").cgColor
        imgNewFeed.layer.cornerRadius = 8
        imgNewFeed.layer.borderWidth = 2
        imgNewFeed.layer.borderColor = UIColor(red: 0.929, green: 0.929, blue: 0.929, alpha: 1).cgColor
        lblTitle.font = UIFont.Poppins.Bold.font(size: 14)
        lblDateTime.font = UIFont.Poppins.Bold.font(size: 10)
        lblDescription.font = UIFont.Poppins.MediumItalic.font(size: 13)
        lblDescription.textColor = .darkGray
    }

    
    func setupCell(with articleVo: ArticleVO) {
        lblTitle.text = articleVo.title ?? ""
        lblDescription.text = articleVo.description ?? ""
        if let date =  XTDateFormatterStruct.xt_fullDateFormatter().date(from: articleVo.publishedAt ?? "0"){
            lblDateTime.text = XTDateFormatterStruct.xt_defaultDateTimeFormatter().string(from: date)
        }
        imgNewFeed.kf.setImage(with: URL(string: articleVo.urlToImage ?? ""),placeholder: UIImage(named: "ic_placeholder"))
    }
}

