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
        switch authViewModel.authenticationState {
        case .unauthenticated:
            LoginIntroView()
                .environmentObject(authViewModel)
        case .authenticated:
            MainTabView()
        }
    }
}

#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(services: StubService())))   // 앱 생성시 주입. 여기서는 프리뷰이므로 테스트용 서비스 주입 
}
