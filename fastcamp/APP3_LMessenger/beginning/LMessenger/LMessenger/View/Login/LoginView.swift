//
//  LoginView.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel       // 로그인뷰의 뷰모델로 AuthenticationViewModel을 사용. Environ으로 해당 뷰모델 가져오기 
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("로그인")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.bkText)
                    .padding(.top, 80)
                
                Text("아래 제공되는 서비스로 로그인을 해주세요.")
                    .font(.system(size: 14))
                    .foregroundColor(.greyDeep)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button(action: {
                authViewModel.send(action: .googleLogin)
                
            }, label: {
                Text("Google로 로그인")
            }).buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Apple로 로그인")
            }).buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            // TODO: back
                            dismiss()
                        } label: {
                            Image("back")
                        }
                    }
                }
        }
    }
}

#Preview {
    LoginView()
}
