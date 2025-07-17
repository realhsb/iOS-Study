//
//  HomeViewController.swift
//  APP4_CCommerce
//
//  Created by Soop on 7/2/25.
//

import UIKit

class HomeViewController: UIViewController {
  
  enum Section: Int {
    case banner
    case horizontalProductItem
    case verticalProductItem
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
  private var compositionalLayout: UICollectionViewCompositionalLayout = setCompositionalLayout()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadData()
    
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
  
  private func loadData() {
    Task {
      do {
        let response = try await NetworkService.shared.getHomeData() // AsyncThrough error 반환
        let bannerViewModels = response.banners.map {
          HomeBannerCollectionViewCellViewModel(bannerImageUrl: $0.imageUrl)
        }
        let horizontalProductViewModels = response.horizontalProducts.map {
          HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl,
                                                 title: $0.title,
                                                 reasonDiscountString: $0.discount,
                                                 originalPrice: "\($0.originalPrice)",
                                                 discountPrice: "\($0.discountPrice)")
        }
        let verticalProductViewModels = response.verticalProducts.map {
          HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl,
                                                 title: $0.title,
                                                 reasonDiscountString: $0.discount,
                                                 originalPrice: "\($0.originalPrice)",
                                                 discountPrice: "\($0.discountPrice)")
        }
        applySnapshot(bannerViewModel: bannerViewModels, horizontalProductViewModel: horizontalProductViewModels, verticalProductViewModel: verticalProductViewModels)
        
      } catch {
        print("network error: \(error)")
      }
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
  
    private func applySnapshot(bannerViewModel: [HomeBannerCollectionViewCellViewModel], horizontalProductViewModel: [HomeProductCollectionViewCellViewModel], verticalProductViewModel: [HomeProductCollectionViewCellViewModel]) {
    
    var snapShot: NSDiffableDataSourceSnapshot<Section, AnyHashable> = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
    snapShot.appendSections([.banner])
    snapShot.appendItems(bannerViewModel, toSection: .banner)
    
    snapShot.appendSections([.horizontalProductItem])
    snapShot
      .appendItems(horizontalProductViewModel, toSection: .horizontalProductItem)
    
    snapShot.appendSections([.verticalProductItem])
    snapShot
        .appendItems(verticalProductViewModel, toSection: .verticalProductItem)
    
    
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
