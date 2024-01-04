//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import Foundation

// 뷰모델을 추가하여 로그인 여부에 따라 AuthenticationView를 분기 처리
enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    
    // 로그인 상태에 따라 뷰를 브랜치하므로 @Published로 선언
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    // 컨테이너를 받아서 뷰모델에 넣어주기
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
}
