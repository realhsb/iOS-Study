//
//  HomeViewController.swift
//  APP4_CCommerce
//
//  Created by Soop on 7/2/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    enum Section: Int {
        case banner
        case horizontalProductItem
        case verticalProductItem
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private var compositionalLayout: UICollectionViewCompositionalLayout = setCompositionalLayout()
    private var viewModel: HomeViewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []  // 바인딩한 걸 관찰하기 위한
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingViewModel()        // 1️⃣ 값을 관찰할 수 있도록 세팅
        viewModel.process(action: .loadData)      // 2️⃣ 데이터 가져오기
        setDataSource()           // 3️⃣ 데이터 소스 세팅
        collectionView.collectionViewLayout = compositionalLayout
    }
    
    private static func setCompositionalLayout() -> UICollectionViewCompositionalLayout { // 초기화할 때 사용할 수 있도록 static으로 선언
        UICollectionViewCompositionalLayout { section, _ in
            switch Section(rawValue: section) {
            case .banner:
                return HomeBannerCollectionViewCell.bannerLayout()
                
            case .horizontalProductItem:
                return HomeProductCollectionViewCell.horizontalProductItemLayout()
                
            case .verticalProductItem:
                return HomeProductCollectionViewCell.verticalProductItemLayout()
                
            case .none: return nil
            }
        }
    }
    
    private func bindingViewModel() { // 1. 값을 관찰
        // $bannerViewModels -> 달러표시는 관찰할 수 있는 친구
        // DispatchQueue.main 에서 진행
        // 홈뷰컨이 살아있는 동안은 계속 관찰 cancellables이 사라지면 이 관찰도 끝 ... cancellables은 홈뷰컨이 사라지면 사라짐
        viewModel.state.$collectionViewModels.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in  // 2. 값이 발생하면 sink가 됨. 각각의 변수 업데이트
                self?.applySnapshot()   // 3. 스냅샷 호출
            }.store(in: &cancellables)
        
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self]  collectionView, indexPath, viewModel in
            
            switch Section(rawValue: indexPath.section) {
                
            case .banner:
                return self?.bannerCell(collectionView, indexPath, viewModel)
                
            case .horizontalProductItem, .verticalProductItem:
                return self?.productItemCell(collectionView, indexPath, viewModel)
                
                
            case .none:
                
                return .init()
            }
        })
    }
    
    private func applySnapshot() {
        
        var snapShot: NSDiffableDataSourceSnapshot<Section, AnyHashable> = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        if let bannerViewModels = viewModel.state.collectionViewModels.bannerViewModels {  // 4. 뷰모델에 해당 값이 있으면
            snapShot.appendSections([.banner])                    // 5. 해당 섹션 생성
            snapShot.appendItems(bannerViewModels, toSection: .banner)  // 6. 섹션에 아이템 추가
        }
        
        if let horizontalProductViewModels = viewModel.state.collectionViewModels.horizontalProductViewModels {
            snapShot.appendSections([.horizontalProductItem])
            snapShot
                .appendItems(horizontalProductViewModels, toSection: .horizontalProductItem)
        }
        
        if let verticalProductViewModels = viewModel.state.collectionViewModels.verticalProductViewModels {
            snapShot.appendSections([.verticalProductItem])
            snapShot
                .appendItems(verticalProductViewModels, toSection: .verticalProductItem)
        }
        
        dataSource?.apply(snapShot) // 7. 스냅샷 업데이트
    }
    
    private func bannerCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ viewModel: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = viewModel as? HomeBannerCollectionViewCellViewModel,
              let cell: HomeBannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as? HomeBannerCollectionViewCell else { return .init() }
        
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func productItemCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ viewModel: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = viewModel as? HomeProductCollectionViewCellViewModel,
              let cell: HomeProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductCollectionViewCell", for: indexPath) as? HomeProductCollectionViewCell else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
}

#Preview {
    UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
}
