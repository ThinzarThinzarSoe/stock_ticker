
import RxSwift
import RxRelay
import Combine

class HomeModel {
    static let shared = HomeModel()
}

extension HomeModel {
    func getNewFeedList() -> AnyPublisher<[ArticleVO],Error> {
        let url = ApiConfig.HomeVC.getNewFeedList.getURLString()
        return ApiClient.shared.requestCombine(url: url, method: .get, parameters: [:]).compactMap { responseData in
            if let articleListResponse = responseData.filterByKey(keys: .articles).decode(modelType: [ArticleVO].self){
                return articleListResponse
            }
            return nil
        }.eraseToAnyPublisher()
    }
}
