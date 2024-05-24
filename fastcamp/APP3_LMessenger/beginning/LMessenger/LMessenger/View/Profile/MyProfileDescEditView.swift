//
//  MyProfileDescEditView.swift
//  LMessenger
//
//  Created by Subeen on 5/24/24.
//  마이프로필 상태메시지 수정 뷰

import SwiftUI

struct MyProfileDescEditView: View {
    @Environment(\.dismiss) var dismiss
    @State var description: String
    
    var onCompleted: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("상태메시지를 입력해주세요", text: $description)
            }
            .toolbar {
                Button("완료") {
                    dismiss()
                    onCompleted(description)
                }
                .disabled(description.isEmpty)  // 메시지가 없을 때는 버튼 비활성화
            }
        }
        
    }
}

#Preview {
    MyProfileDescEditView(description: "") { _ in
        
    }
}
