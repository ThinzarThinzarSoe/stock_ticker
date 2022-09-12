
import RxSwift
import RxCocoa
import Combine

class BaseViewModel {
    let disposableBag = DisposeBag()
    
    var bindings = Set<AnyCancellable>()
    
    weak var viewController : BaseViewController?
    let errorPublisher = PassthroughSubject<Error,Never>()
    
    let showErrorMessagePublisher = CurrentValueSubject<String?,Never>(nil)
    let loadingPublisher = CurrentValueSubject<Bool,Never>(false)
    var isGifLoadingView = false
    let isNoDataPublisher = PassthroughSubject<Bool,Never>()
    let isNoInternetPublisher = PassthroughSubject<Bool,Never>()
    let isSeverErrorPublisher = PassthroughSubject<Bool,Never>()
    let isEmptyCategoryListPublisher = PassthroughSubject<Bool,Never>()

    var isShowNoDataPageForUnKnownError: Bool = true

    init() {
        
    }
    deinit {
        debugPrint("Deinit \(type(of: self))")
    }
    func bindViewModel(in viewController: BaseViewController? = nil,
                       isDataShowingPage: Bool = true) {
        self.viewController = viewController
        isShowNoDataPageForUnKnownError = isDataShowingPage
        
        loadingPublisher.sink { [weak self] (result) in
            if result {
                self?.viewController?.showLoading()
            } else {
                self?.viewController?.hideLoading()
            }
        
        }.store(in: &bindings)
        
        errorPublisher.sink { [weak self] (error) in
            self?.viewController?.hideLoading()
            if let error = error as? ErrorType {
                switch error {
                case .NoInterntError:
                    self?.isNoInternetPublisher.send(true)
                case .KnownError(let message):
                    self?.viewController?.showToast(message: message)
                case .UnKnownError:
                    if self?.isShowNoDataPageForUnKnownError ?? false {
                        self?.isSeverErrorPublisher.send(true)
                    }else {
                        self?.viewController?.showToast(message: "Something Went Wrong")
                    }
                default:
                    self?.isSeverErrorPublisher.send(true)
                }
            }
        }.store(in: &bindings)
        
        showErrorMessagePublisher.sink { [weak self] (errorMessage) in
            if let message = errorMessage {
                self?.viewController?.showToast(message: message, isShowing: {
                    self?.viewController?.view.isUserInteractionEnabled = false
                }, completion: {
                    self?.viewController?.view.isUserInteractionEnabled = true
                })
            }
        }.store(in: &bindings)
    }
}
