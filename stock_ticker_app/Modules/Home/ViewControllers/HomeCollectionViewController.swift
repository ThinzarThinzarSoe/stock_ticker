
import UIKit
import Combine

class HomeCollectionViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    let viewModel: HomeViewModel = .init()
    var articleList : [ArticleVO]?
    var horizontalNewFeedList : [ArticleVO]?
    var remainingNewFeedList : [ArticleVO]?
    var randomStockList = [StockVO]()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        viewModel.getNewFeedList()
        generateRandomStockPrice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationTitle(title: "Stock And NewFeed")
        showNavigationBar()
        runTimer()
    }

    override func setupUI() {
        super.setupUI()
        setUpCollectionView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        viewModel.bindViewModel(in: self)
    }
    
    override func bindData() {
        super.bindData()
        viewModel.articleListPublisher.sink {[unowned self] in
            if let list = $0 ,
               !list.isEmpty {
                self.articleList = list
                self.horizontalNewFeedList = Array(self.articleList?[safe: 0..<6] ?? [])
                self.remainingNewFeedList = Array(self.articleList?[safe: 6..<list.count] ?? [])
                collectionView.reloadData()
            }
        }.store(in: &bindings)
        
        viewModel.isNoDataPublisher.sink { _ in
            self.isShowNoDataAndInternet(isShow: true)
        }.store(in: &bindings)
        
        viewModel.isSeverErrorPublisher.sink {
            if $0 {
                if self.articleList == nil{
                    self.showToast(message: "No Internet")
                }
            } else {
                self.isShowNoDataAndInternet(isShow: $0 , isServerError: $0)
            }
        }.store(in: &bindings)
        
        viewModel.isNoInternetPublisher.sink {
            self.isShowNoDataAndInternet(isShow: $0)
        }.store(in: &bindings)
    }
    
    override func reloadScreen() {
        super.reloadScreen()
        viewModel.getNewFeedList()
        generateRandomStockPrice()
    }
}

// MARK: - collectionView setup & layout
extension HomeCollectionViewController {
    func setUpCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] index, _ in
            switch viewModel.sectionTypes[index] {
            case .stockTickers:
                return CollectionViewLayout(itemCount: 3, groupWidth: 0.9, isHorizontalScroll: true , itemHeight: 0.1)
            case .newFeeds:
                return CollectionViewLayout(itemCount: 1, groupWidth: 0.9, isHorizontalScroll: true)
            case .remainingNewFeeds:
                return CollectionViewLayout(itemCount: 1, groupWidth: 1.0, isHorizontalScroll: false)
            }
        }))
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.registerForCells(cells:[NewFeedItemCollectionViewCell.self,
             NewFeedHorizontalItemCollectionViewCell.self,
             StockPriceItemCollectionViewCell.self])
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    func CollectionViewLayout(itemCount : Int , groupWidth : CGFloat , isHorizontalScroll : Bool , itemHeight : CGFloat = 0.3) -> NSCollectionLayoutSection {
        let height = ("text".size(withAttributes: [.font: UIFont.Poppins.Bold.font(size: 12)]).height * 3) + (view.bounds.width * itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: isHorizontalScroll ? 10 : 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(groupWidth), heightDimension: .absolute(height)), subitem: item, count: itemCount)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        if isHorizontalScroll {
            section.orthogonalScrollingBehavior = .continuous
        }
        return section
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if collectionView != nil {
            collectionView.reloadData()
        }
    }
}

// MARK: - collectionView delegate & datasource
extension HomeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sectionTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.sectionTypes[section] {
        case .stockTickers:
            return self.randomStockList.count
        case .newFeeds:
            return self.horizontalNewFeedList?.count ?? 0
        case .remainingNewFeeds:
            return self.remainingNewFeedList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sectionTypes[indexPath.section] {
        case .stockTickers:
            return getStockTickerCell(indexPath)
        case .newFeeds:
            return getNewFeedHorizontalCell(indexPath)
        case .remainingNewFeeds:
            return getNewFeedVerticalCell(indexPath)
        }
    }
}

// MARK: - register cell
extension HomeCollectionViewController {

    func getStockTickerCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReuseCell(type: StockPriceItemCollectionViewCell.self, indexPath: indexPath)
        cell.setupCell(with: self.randomStockList[indexPath.item])
        return cell
    }
    
    func getNewFeedVerticalCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReuseCell(type: NewFeedItemCollectionViewCell.self, indexPath: indexPath)
        if let item = self.remainingNewFeedList?[indexPath.item] {
            cell.setupCell(with: item)
        }
        return cell
    }
    
    func getNewFeedHorizontalCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReuseCell(type: NewFeedHorizontalItemCollectionViewCell.self, indexPath: indexPath)
        cell.setupCell(with: self.horizontalNewFeedList?[indexPath.item])
        return cell
    }
}

// MARK: - read csv data from web
extension HomeCollectionViewController {
    func readStringFromURL(stringURL:String)-> [[StockVO]]{
        var stockList : [StockVO] = []
        do {
            let url = NSURL(string: stringURL)
            let file = try String(contentsOf: url! as URL)
            var rows = file.components(separatedBy: .newlines)
            rows.remove(at: 0)
            rows.forEach { item in
                let components = item.components(separatedBy: ", ")
                stockList.append(StockVO(stockName: components.first, price: Double(components.last ?? "0.0")))
            }
        } catch {
            print(error)
        }
        return stockList.group { $0.stockName }
    }
}

// MARK: - fetch stock data every 1000ms and generate random stock price
extension HomeCollectionViewController {
    func runTimer(){
        self.timer = Timer(fire: Date(), interval: 1000, repeats: true, block: { (Timer) in
            self.randomStockList.removeAll()
            DispatchQueue.main.async {
                self.generateRandomStockPrice()

            }
        })
        RunLoop.current.add(self.timer, forMode: .default)
    }
    
    func generateRandomStockPrice(){
        let stringURL = ApiConfig.HomeVC.getStockList.getURLString()
        readStringFromURL(stringURL: stringURL).forEach { dataList in
            if !dataList.isEmpty {
                if let stockVo = dataList.randomElement() {
                    self.randomStockList.append(stockVo)
                }
            }
        }
        collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
    }
}
