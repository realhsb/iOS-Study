//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import Foundation
import Combine

// 뷰모델을 추가하여 로그인 여부에 따라 AuthenticationView를 분기 처리
enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    
    // 뷰에서 일어나는 액션 정의
    enum Action {
        case googleLogin
    }
    
    // 로그인 상태에 따라 뷰를 브랜치하므로 @Published로 선언
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    var userId: String?
    
    
    // 컨테이너를 받아서 뷰모델에 넣어주기
    private var container: DIContainer
    private var subsriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) { // 구글 로그인 액션 
        switch action {
        case .googleLogin:
            container.services.authService.signInWithGoogle()
                .sink { completion in   // sink 했을 때 subscription이 반환, 뷰모델에서는 구독이 여러 개 가능. 이를 subsription을 set으로 해서 알림
                    // TODO:
                } receiveValue: { [weak self] user in   // 유저 정보가 오면, 이 뷰모델에서 유저 아이디 갖게 하기
                    self?.userId = user.id
                }.store(in: &subsriptions) // sub을 통해 구독을 하면, subscriptions 변수에 저장됨 
        }
    }
}
