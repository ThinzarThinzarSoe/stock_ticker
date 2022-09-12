
import Foundation

enum ErrorType: Error {
    case NoInterntError
    case NoDataError
    case SeverError
    case KnownError(_ errorMessage: String)
    case UnKnownError
    case TokenExpireError(_ code : Int)
}
