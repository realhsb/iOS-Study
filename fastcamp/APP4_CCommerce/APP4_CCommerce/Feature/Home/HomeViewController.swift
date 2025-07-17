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
  private var cancellables: Set<AnyCancellable> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindingViewModel()
    viewModel.loadData()
    setDataSource()
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
  
  private func bindingViewModel() {
    // $bannerViewModels -> 달러표시는 관찰할 수 있는 친구
    // DispatchQueue.main 에서 진행
    // 홈뷰컨이 살아있는 동안은 계속 관찰 cancellables이 사라지면 이 관찰도 끝 ... cancellables은 홈뷰컨이 사라지면 사라짐
    viewModel.$bannerViewModels.receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.applySnapshot()
      }.store(in: &cancellables)
    
    viewModel.$horizontalProductViewModels.receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.applySnapshot()
      }
    
    viewModel.$verticalProductViewModels.receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.applySnapshot()
      }
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
    
      if let bannerViewModels = viewModel.bannerViewModels {  // 데이터가 있을 때만 아이템에 데이터 넣어주기
        snapShot.appendSections([.banner])
        snapShot.appendItems(bannerViewModels, toSection: .banner)
      }
    
      if let horizontalProductViewModels = viewModel.horizontalProductViewModels {
        snapShot.appendSections([.horizontalProductItem])
        snapShot
          .appendItems(horizontalProductViewModels, toSection: .horizontalProductItem)
      }
      
      if let verticalProductViewModels = viewModel.verticalProductViewModels {
        snapShot.appendSections([.verticalProductItem])
        snapShot
          .appendItems(verticalProductViewModels, toSection: .verticalProductItem)
      }
    
    dataSource?.apply(snapShot)
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
