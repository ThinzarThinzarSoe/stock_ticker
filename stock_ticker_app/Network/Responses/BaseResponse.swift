
import Foundation

struct BaseResponse : Codable {
    
    let message : String?
    let status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status
    }
    
}
