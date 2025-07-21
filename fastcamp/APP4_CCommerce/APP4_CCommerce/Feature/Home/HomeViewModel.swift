//
//  HomeViewModel.swift
//  APP4_CCommerce
//
//  Created by Soop on 7/18/25.
//

import Combine
import Foundation

class HomeViewModel {
    
    enum Action {
        case loadData
        case getDateSuccess(HomeResponse)
        case getDataFailure(Error)
    }
    
    final class State {
        struct CollectionViewModels {
            
            // 값을 받고, UI를 업데이트 해야 함 -> 메인스레드에서 동작 해야 함
            // 함수 실행을 끝냈을 때 메인 액터에서 동작하도록 함.
            
            // 2. 여기있는 상태가 업데이트
            var bannerViewModels: [HomeBannerCollectionViewCellViewModel]?
            var horizontalProductViewModels: [HomeProductCollectionViewCellViewModel]?
            var verticalProductViewModels: [HomeProductCollectionViewCellViewModel]?
        }
        @Published var collectionViewModels: CollectionViewModels = CollectionViewModels()  // 1. 얘를 변경하면
    }
    private(set) var state: State = State()
    private var loadDataTask: Task<Void, Never>?
    
    func process(action: Action) {
        switch action {
        case .loadData:
            loadData()
            
        case let .getDateSuccess(response): // 조회 성공 시, response 넘겨줌
            transformResponse(response)
             
        case let .getDataFailure(error):
            print("network error: \(error)")
        }
    }
    
    private func loadData() {
        Task {  // 비동기, 뷰모델이 없어져도 task는 마저 동작하고 deinit이 호출될 수 있음.
            do {

                let response = try await NetworkService.shared.getHomeData() // AsyncThrough error 반환
                process(action: .getDateSuccess(response))
                // 각각 동작. 병렬적으로 동작.

            } catch {
                process(action: .getDataFailure(error))
                
            }
        }
    }
    
    private func transformResponse(_ response: HomeResponse) {
        Task { await transformBanner(response) }  // 값을 받아와서 bannerViewModels에 세팅
        Task { await transformHorizontalProduct(response) }
        Task { await transformVerticalProduct(response) }
    }
    
    // async 붙인 이유? 메인 액터도 async하게 동작하는 걸 보장
    @MainActor
    private func transformBanner(_ response: HomeResponse) async {
        state.collectionViewModels.bannerViewModels = response.banners.map {
            HomeBannerCollectionViewCellViewModel(bannerImageUrl: $0.imageUrl)
        }
    }
    
    @MainActor
    private func transformHorizontalProduct(_ response: HomeResponse) async {
        state.collectionViewModels.horizontalProductViewModels = response.horizontalProducts.map {
            HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl,
                                                   title: $0.title,
                                                   reasonDiscountString: $0.discount,
                                                   originalPrice: "\($0.originalPrice)",
                                                   discountPrice: "\($0.discountPrice)")
        }
    }
    
    @MainActor
    private func transformVerticalProduct(_ response: HomeResponse) async {
        state.collectionViewModels.verticalProductViewModels = response.verticalProducts.map {
            HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl,
                                                   title: $0.title,
                                                   reasonDiscountString: $0.discount,
                                                   originalPrice: "\($0.originalPrice)",
                                                   discountPrice: "\($0.discountPrice)")
        }
    }
    
    deinit {  // 뷰모델이 사라져야할 때 비동기 진행을 취소시킴
        loadDataTask?.cancel()
    }
    
    private func productToHomeProductCollectionViewCellViewModel(_ product: [Product]) -> [HomeProductCollectionViewCellViewModel] {
        return product.map {
            HomeProductCollectionViewCellViewModel(
                imageUrlString: $0.imageUrl,
                title: $0.title,
                reasonDiscountString: $0.discount,
                originalPrice: $0.originalPrice.moneyString,    // 가격에 콤마 넣기
                discountPrice: $0.discountPrice.moneyString
            )
        }
    }
}
