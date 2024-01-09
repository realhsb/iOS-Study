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
        case checkAuthenticationState
        case googleLogin
    }
    
    // 로그인 상태에 따라 뷰를 브랜치하므로 @Published로 선언
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading = false
    
    var userId: String?
    
    
    // 컨테이너를 받아서 뷰모델에 넣어주기
    private var container: DIContainer
    private var subsriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) { // 구글 로그인 액션 
        switch action {
        case .checkAuthenticationState:
            if let userId = container.services.authService.checkAuthenticationState() {
                self.userId = userId
                self.authenticationState = .authenticated   // 유저 정보가 있을 시, 로그인 유지
            }
            
        case .googleLogin:
            container.services.authService.signInWithGoogle()
            
            container.services.authService.signInWithGoogle()   // -> AnyPublisher<User, ServiceError> : 성공시 User 정보가 방출됨
            // TODO: 로그인 성공 후 db에 추가
                .flatMap { user in
                    self.container.services.userService.addUser(user) // 로그인 성공 후 db에 추가
                }
                    }
                    
                } receiveValue: { [weak self] user in   // 유저 정보가 오면, 이 뷰모델에서 유저 아이디 갖게 하기
                    self?.userId = user.id
                    self?.authenticationState = .authenticated
                }.store(in: &subsriptions) // sub을 통해 구독을 하면, subscriptions 변수에 저장됨
        }
    }
}
