
struct NewFeedVO : Codable {
    let status : String?
    let totalResults : Int?
    let articles : [ArticleVO]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
    }
}
