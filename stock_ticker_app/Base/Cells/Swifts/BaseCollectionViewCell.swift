
import UIKit
import RxSwift
import RxCocoa
import Combine

class BaseCollectionViewCell: UICollectionViewCell {
    var bindings = Set<AnyCancellable>()
    var disposableBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupLanguage()
        setupTest()
        bindData()
    }
    
    func setupUI(){
        
    }
    
    func setupLanguage(){
        
    }
    
    func setupTest(){
        
    }
    
    func bindData(){
        
    }
    
}
