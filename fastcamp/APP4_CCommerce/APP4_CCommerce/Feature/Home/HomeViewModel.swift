//
//  HomeViewModel.swift
//  APP4_CCommerce
//
//  Created by Soop on 7/18/25.
//

import Combine
import Foundation

class HomeViewModel {
  
  @Published var bannerViewModels: [HomeBannerCollectionViewCellViewModel]?
  @Published var horizontalProductViewModels: [HomeProductCollectionViewCellViewModel]?
  @Published var verticalProductViewModels: [HomeProductCollectionViewCellViewModel]?
  
  private var loadDataTask: Task<Void, Never>?
  
  func loadData() {
    Task {  // 비동기, 뷰모델이 없어져도 task는 마저 동작하고 deinit이 호출될 수 있음.
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
        self.bannerViewModels = bannerViewModels
        self.horizontalProductViewModels = horizontalProductViewModels
        self.verticalProductViewModels = verticalProductViewModels
        
      } catch {
        print("network error: \(error)")
      }
    }
  }
  
  deinit {  // 뷰모델이 사라져야할 때 비동기 진행을 취소시킴
    loadDataTask?.cancel()
  }
}
