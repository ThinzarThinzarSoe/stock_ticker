
import UIKit

protocol ErrorHandlerDelegate: AnyObject {
    func didTapRetry()
}

class ErrorHandlerView: BaseView {
    
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblErrorTitle: UILabel!
    @IBOutlet weak var lblErrorDesc: UILabel!
    @IBOutlet weak var btnRetry: RoundedCornerUIButton!
    @IBOutlet weak var btnRetryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintForTryAgain: NSLayoutConstraint!
    
    weak var delegate : ErrorHandlerDelegate?
    
    override func setupUI() {
        super.setupUI()
        lblErrorTitle.font = .Poppins.Bold.font(size: 20)
        lblErrorDesc.font = .Poppins.Regular.font(size: 14)
        lblErrorTitle.textColor = .lightGray
        lblErrorDesc.textColor = .lightGray
        btnRetry.titleLabel?.font = .Poppins.Bold.font(size: 20)
        btnRetry.titleLabel?.textColor = .white
    }

    func setupView(isShow : Bool , errorVo : ErrorVO? , isServerError : Bool = false) {
        var error_image : UIImage?
        var error_title : String?
        var error_desc : String?
        var isInternetAvailable = Bool()
        
        ApiClient.checkReachable(success: {
            isInternetAvailable = true
            if let error = errorVo {
                error_image = UIImage(named: error.image ?? "")
                error_title = error.title
                error_desc = error.description
            } else {
                error_image = #imageLiteral(resourceName: "ic_no_data")
                error_title = "No Data"
                error_desc = ""
            }

        }) {
            isInternetAvailable = false
            error_image = #imageLiteral(resourceName: "ic_no_internet")
            error_title = ""
            error_desc = "No Internet"
        }

        if isServerError {
            error_image = #imageLiteral(resourceName: "ic_server_error")
            error_title = "Server Error"
            isInternetAvailable = false
            error_desc = ""
        }
    
        imgError.image = error_image
        lblErrorTitle.text = error_title
        lblErrorDesc.text = error_desc
        btnRetry.isUserInteractionEnabled = true
        layoutIfNeeded()
        layoutSubviews()
        setNeedsLayout()
    }

    func removeView() {
        removeFromSuperview()
    }
    
    @IBAction func onClickRetry(_ sender: Any) {
        removeView()
        delegate?.didTapRetry()
//        if ApiClient.checkReachable() {
//            removeView()
//            delegate?.didTapRetry()
//        }
    }
}


