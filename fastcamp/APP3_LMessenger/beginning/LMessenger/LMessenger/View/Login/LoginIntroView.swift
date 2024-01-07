//
//  LoginIntroView.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import SwiftUI

struct LoginIntroView: View {
    // 내비게이션 구조가 복잡하지 않으므로 변수로 설정
    @State private var isPresentedLoginView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Text("환영합니다")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.bkText)
                
                Text("무료 메시지와 영상통화, 음성통화를 부담없이 즐겨보세요!")
                    .font(.system(size: 12))
                    .foregroundColor(.greyDeep)
                
                Spacer()
                
               
                Button(
                    action: {
                        // TODO: LoginView로 푸쉬
                        isPresentedLoginView.toggle()
                    },
                    label: {
                        Text("로그인")
                    }).buttonStyle(LoginButtonStyle(textColor: .lineAppColor))
            }
            .navigationDestination(isPresented: $isPresentedLoginView) {
                LoginView()
            }
        }
    }
}

#Preview {
    LoginIntroView()
}
