
import Combine

enum HomeSection: Int {
    case stockTickers = 0
    case newFeeds = 1
    case remainingNewFeeds = 2
}

class HomeViewModel: BaseViewModel {
    let model = HomeModel.shared
    let stockListPublisher = CurrentValueSubject<[[StockVO]]?, Never>(nil)
    let articleListPublisher = CurrentValueSubject<[ArticleVO]?, Never>(nil)
    let sectionTypes : [HomeSection] = [.stockTickers , .newFeeds , .remainingNewFeeds]
}

extension HomeViewModel {
    func getNewFeedList() {
        loadingPublisher.send(true)
        model.getNewFeedList().sink(receiveCompletion: {[unowned self] in
            loadingPublisher.send(false)
            guard case .failure(let error) = $0 else {return}
            errorPublisher.send(error)
        }) { [unowned self] (list) in
            loadingPublisher.send(false)
            if list.isEmpty {
                isNoDataPublisher.send(true)
            } else {
                articleListPublisher.send(list)
            }
        }.store(in: &bindings)
    }
}
