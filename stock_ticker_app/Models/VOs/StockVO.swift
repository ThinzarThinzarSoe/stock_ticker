
import Foundation
struct StockVO : Codable {
    let stockName : String?
    let price : Double?

    enum CodingKeys: String, CodingKey {

        case stockName = "stockName"
        case price = "price"
    }
}
