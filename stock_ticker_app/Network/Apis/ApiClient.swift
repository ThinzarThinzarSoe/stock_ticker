
import Reachability
import SystemConfiguration
import Alamofire
import RxCocoa
import RxSwift
import SwiftyJSON
import Combine

class ApiClient {
    //MARK:- NETWORK CALLS
    static let shared = ApiClient()
    
    private let APIManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        let delegate = Session.default.delegate
        let manager = Session.init(configuration: configuration,
                                   delegate: delegate)
        return manager
    }()

    public func requestCombine(url : String,
                               method : HTTPMethod = .get,
                               parameters : Parameters = [:],
                               headers : HTTPHeaders = [:]) -> AnyPublisher<Data,Error> {
        var headers = headers
        headers["Content-Type"] = "application/json"
        let encoding : ParameterEncoding = (method == .get ? URLEncoding.default : JSONEncoding.default)
        return Future<Data,Error>{ [unowned self] promise in
            APIManager.request(url, method: method, parameters: parameters,encoding: encoding, headers: headers).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    promise(.success(response.data as Any as! Data))
                case .failure:
                    promise(.failure(ErrorType.NoInterntError))
                }
            }
        }.eraseToAnyPublisher()
    }
}


//MARK:- CHECK NETWORK
extension ApiClient {
    
    static func isOnline(callback: @escaping (Bool) -> Void){
        
        let reachability = try! Reachability()
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                callback(true)
            } else {
                print("Reachable via Cellular")
                callback(true)
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            callback(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
            callback(false)
        }
    }
    
    static func checkReachable() -> Bool{
        let reachability = SCNetworkReachabilityCreateWithName(nil, "https://mmtrv.link/admin/login")
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        if (isNetworkReachable(with: flags))
        {
            if flags.contains(.isWWAN) {
                return true
            }
                        
            return true
        }
        else if (!isNetworkReachable(with: flags)) {
            return false
        }
        
        return false
    }
    
    static func checkReachable(success : @escaping () -> Void,
                               failure : @escaping () -> Void){
        
        if checkReachable() {
            success()
        }else{
            failure()
        }
        
    }
    
    static func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
}
