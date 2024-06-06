//
//  URLImageViewModel.swift
//  LMessenger
//
//  Created by Subeen on 6/7/24.
//

import UIKit
import Combine

class URLImageViewModel: ObservableObject {
    
    var loadingOrSuccess: Bool {    // 로딩 시작됐거나, 이미지 가져왔을 때 다시 요청하지 않게
        return loading || loadedImage != nil
    }
    
    @Published var loadedImage: UIImage?
    
    private var loading: Bool = false
    private var urlString: String
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, urlString: String) {   // urlString : 이미지 url
        self.container = container
        self.urlString = urlString
    }
}

extension URLImageViewModel {
    
    /// 캐시에서 이미지 가져오기
    func start() {
        guard !urlString.isEmpty else { return }
        
        loading = true // 로딩 시작
        
        container.services.imageCacheService.image(for: urlString)
            .subscribe(on: DispatchQueue.global()) // 작업이 복잡하므로, 글로벌큐(백그라운드)에서 작업하도록 함
            .receive(on: DispatchQueue.main) // 응답 받은 후, 메인 큐에서 작업하도록
            .sink { [weak self] image in
                self?.loading = true
                self?.loadedImage = image
            }.store(in: &subscriptions)
    }
}
