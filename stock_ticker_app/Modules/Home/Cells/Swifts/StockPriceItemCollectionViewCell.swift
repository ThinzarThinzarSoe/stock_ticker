
import UIKit

class StockPriceItemCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func setupUI() {
        super.setupUI()
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor("#EDEDED").cgColor
        lblPrice.textColor = .white
        lblPrice.font = UIFont.Poppins.Bold.font(size: 13)
        lblTitle.textColor = .white
        lblTitle.font = UIFont.Poppins.Bold.font(size: 12)
    }
    
    func setupCell(with stockVo: StockVO?) {
        if let stockVo = stockVo {
            lblTitle.text = stockVo.stockName?.replacingOccurrences(of: "\"", with: "")
            lblPrice.text = "$" + "\(stockVo.price?.rounded(toPlaces: 5) ?? 0.0)".replacingOccurrences(of: "-", with: "")
        }
    }
}
