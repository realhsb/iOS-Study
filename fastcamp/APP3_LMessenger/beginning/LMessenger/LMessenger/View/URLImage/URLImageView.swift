//
//  URLImageView.swift
//  LMessenger
//
//  Created by Subeen on 6/7/24.
//

import SwiftUI

struct URLImageView: View {
    @EnvironmentObject var container: DIContainer
    
    let urlString: String?
    let placeholderName: String
    
    init(urlString: String?, placeholderName: String? = nil) {
        self.urlString = urlString
        self.placeholderName = placeholderName ?? "placeholder"
    }
    
    var body: some View {
        if let urlString, !urlString.isEmpty {
            URLInnerImageView(viewModel: .init(container: container, urlString: urlString), placeholderName: placeholderName)
                .id(urlString)
            // id modifier 추가, 이너뷰가 url 변경시 내부의 stateobject로 변경하기 위해서 명시적인 id cnrk
            
        } else {
            Image(placeholderName)
                .resizable()
        }
    }
}


fileprivate struct URLInnerImageView: View {
    
    /// 자주 사용될 뷰인데, 이렇게 두면 매번 뷰모델을 선언해야 함... 번거로우니 이너뷰로 바꿈
    @StateObject var viewModel: URLImageViewModel
    
    let placeholderName: String
    
    var placeholderImage: UIImage {
        UIImage(named: placeholderName) ?? UIImage()
    }
    
    var body: some View {
        Image(uiImage: viewModel.loadedImage ?? placeholderImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onAppear {
                if viewModel.loadingOrSuccess {
                    viewModel.start()
                }
            }
    }
}

#Preview {
    URLImageView(urlString: nil)
}
