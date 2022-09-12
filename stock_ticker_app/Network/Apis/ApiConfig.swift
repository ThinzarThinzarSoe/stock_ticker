
import Foundation

struct ApiConfig {
    
    static let NullState = "null"
    
    enum HomeVC {
        case getStockList
        case getNewFeedList
        
        func getURLString() -> String {
            switch self {
            case .getNewFeedList :
                return "https://saurav.tech/NewsAPI/everything/cnn.json"
            case .getStockList:
                return "https://raw.githubusercontent.com/dsancov/TestData/main/stocks.csv"
            }
        }
    }
}
