
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Combine

class BaseViewController : UIViewController {
    
    var bindings = Set<AnyCancellable>()
    var errorHandlerView : ErrorHandlerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        bindViewModel()
        setupLanguage()
        setNavigationColor()
    }
    
    func setupUI() {
        
    }
    
    func bindData() {
        
    }
    
    func setupLanguage(){
        
    }
    
    func bindViewModel() {
        
    }
    
    func reloadScreen() {
        setupUI()
        setupLanguage()
        setNavigationColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppScreens.shared.currentVC = self
        checkViewControllerAndAddBackBtn(vc: self)
    }
    
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func removeNavigationBorder(){
        navigationController?.isHiddenUnderline = true
    }
    
    func checkViewControllerAndAddBackBtn(vc : UIViewController) {
        if !isTopViewController(vc: vc){
            addBackButton()
            showNavigationBar()
        } else {
            hideNavigationBar()
        }
    }
    
    func isTopViewController(vc : UIViewController) -> Bool {
        return navigationController?.children.first == vc
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get{
            return .portrait
        }
    }
    
    func setNavigationColor(){
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor("#000000"),NSAttributedString.Key.font: UIFont.Poppins.Medium.font(size: 18)]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            if let navigationBar = navigationController?.navigationBar {
                let navigationLayer = CALayer()
                var bounds = navigationBar.bounds
                navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor("#000000"),NSAttributedString.Key.font: UIFont.Poppins.Medium.font(size: 18)]
                
                if #available(iOS 13.0, *) {
                    bounds.size.height += view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                } else {
                    bounds.size.height += UIApplication.shared.statusBarFrame.height
                }
                
                navigationLayer.frame = bounds
                navigationLayer.backgroundColor = UIColor.white.cgColor
                
                if let image = getImageFrom(layer: navigationLayer) {
                    navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                }
            }
        }
        
    }
    
    func isShowNoDataAndInternet(isShow : Bool , errorVo : ErrorVO? = nil , isServerError : Bool = false) {
        errorHandlerView?.removeFromSuperview()
        errorHandlerView = ErrorHandlerView(frame: view.frame)
        errorHandlerView?.translatesAutoresizingMaskIntoConstraints = false
        errorHandlerView?.delegate = self
        if isShow {
            errorHandlerView?.setupView(isShow: isShow, errorVo : errorVo , isServerError: isServerError)
            view.addSubview(errorHandlerView!)
            errorHandlerView?.snp.makeConstraints({ (errorView) in
                errorView.left.equalToSuperview()
                errorView.right.equalToSuperview()
                errorView.centerY.equalToSuperview()
            })
            
        } else {
            errorHandlerView?.removeView()
        }
    }
}

extension BaseViewController : ErrorHandlerDelegate {

    func didTapRetry() {
        ApiClient.checkReachable(success: {[unowned self] in
            isShowNoDataAndInternet(isShow: false)
            reloadScreen()
        }) {[unowned self] in
            //not reachable
            showNoInternetConnectionToast()
            isShowNoDataAndInternet(isShow: true)
        }
    }
}
