//
//  myProfileView.swift
//  LMessenger
//
//  Created by Subeen on 4/13/24.
//

/// 프로필뷰 등장 -> 해당 유저 정보 가져와서 세팅 -> async await로 작업 

import SwiftUI

struct MyProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: MyprofileViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("profile_bg") // 기본적으로 이미지는 safe area 포함하지 않음
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .vertical)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    profileView
                        .padding(.bottom, 16)
                    
                    nameView
                        .padding(.bottom, 26)
                    
                    descriptionView
                    
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
            
            .task { // onAppear가 실행되기 전에 실행 
                await viewModel.getUser()
            }
        }
    }
    
    var profileView: some View {
        Button {
            // TODO:
        } label: {
            Image("person")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
    }
    
    var nameView: some View {
        Text(viewModel.userInfo?.name ?? "이름")
            .font(.system(size: 24, weight: .bold))
//            .foregroundStyle()
            .foregroundColor(.bgWh)
    }
    
    var descriptionView: some View {
        Button {
            // TODO:
        } label: {
            Text(viewModel.userInfo?.description ?? "상태메시지를 입력해주세요.")
                .font(.system(size: 14))
                .foregroundColor(.bgWh)
        }
    }
    
    var menuView: some View {
        HStack(alignment: .top, spacing: 27) {
            // TODO:
            ForEach(MyProfileMenuType.allCases, id: \.self) { menu in
                Button {
                } label: {
                    VStack(alignment: .center) {
                        Image(menu.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        Text(menu.description)
                            .font(.system(size: 10))
                            .foregroundColor(.bgWh)
                    }
                }
            }
        }
    }
}

#Preview {
    MyProfileView(viewModel: .init(container: DIContainer(services: StubService()), userId: "user1_id"))
}
