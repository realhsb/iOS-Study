//
//  LoginButtonStyle.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import SwiftUI

struct LoginButtonStyle: ButtonStyle {
    
    let textColor: Color
    let borderColor: Color
    
    init(textColor: Color, borderColor: Color? = nil) {
        self.textColor = textColor
        self.borderColor = borderColor ?? textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 0.8)
            }
            .padding(.horizontal, 15)
            .opacity(configuration.isPressed ? 0.5 : 1)
        
        // configuration.isPressed 버튼 눌렸을 때
        
    }
}


/*
 Button(
     action: {
         // TODO: LoginView로 푸쉬
         isPresentedLoginView.toggle()
     },
     label: {
         Text("로그인")
             .font(.system(size: 14))
             .foregroundColor(.lineAppColor)
             .frame(maxWidth: .infinity, maxHeight: 40)
 })
 .overlay {
     RoundedRectangle(cornerRadius: 5)
         .stroke(Color.lineAppColor, lineWidth: 0.8)
 }
 .padding(.horizontal, 15)
 */
