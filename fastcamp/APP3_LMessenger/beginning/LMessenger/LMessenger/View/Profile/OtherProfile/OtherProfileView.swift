//
//  otherProfileView.swift
//  LMessenger
//
//  Created by Subeen on 4/13/24.
//

import SwiftUI

struct OtherProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: OtherProfileViewModel
    
    var goToChat: (User) -> Void // 대화 버튼을 눌렀을시, 처리할 클로저.
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("profile_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .vertical)
                VStack {
                    Spacer()
                    
                    URLImageView(urlString: viewModel.userInfo?.profileURL)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.bottom, 16)
                    
                    Text(viewModel.userInfo?.name ?? "이름")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.whiteFix)
                    
                    Spacer()
                    
                    menuView
                        .padding(.bottom, 58)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("close")
                    }
                }
            }
            .task {
                await viewModel.getUser() // 실행시 작동
            }
        }
    }
    
    var menuView: some View {
        HStack(alignment: .top, spacing: 50) {
            ForEach(OtherProfileMenuType.allCases, id: \.self) { menu in
                Button { // 대화 버튼 눌렀을 시
                    if menu == .chat, let userInfo = viewModel.userInfo { // viewModel.userInfo가 옵셔널이므로, 옵셔널 제거후 전달
                        dismiss()   // 프로필창이 닫히고, 채팅방으로 이동 
                        goToChat(userInfo)
                    }
                } label: {
                    VStack(alignment: .center) {
                        Image(menu.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(menu.description)
                            .font(.system(size: 10))
                            .foregroundColor(.whiteFix)
                    }
                }
            }
        }
    }
}

struct OtherProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OtherProfileView(viewModel: .init(container: DIContainer(services: StubService()), userId: "user2_id")) { _ in
        }
    }
}
