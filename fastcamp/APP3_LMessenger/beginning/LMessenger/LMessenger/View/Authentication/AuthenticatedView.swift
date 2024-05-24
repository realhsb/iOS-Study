//
//  AuthenticatedView.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject var authViewModel: AuthenticationViewModel // 뷰모델 초기화 시점 -> 이 뷰를 만들 때. 왜? 뷰모델에서 컨테이너를 초기화할 때 주입해줄 예정.
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainTabView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
//            authViewModel.send(action: .logout)
            authViewModel.send(action: .checkAuthenticationState)   // 상태가 업데이트됐다면, 그 상태에 따라 뷰를 보여줄 것
        }
    }
        
}

#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(services: StubService())))   // 앱 생성시 주입. 여기서는 프리뷰이므로 테스트용 서비스 주입 
}
