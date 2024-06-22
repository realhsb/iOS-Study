//
//  ChatView.swift
//  LMessenger
//
//  Created by Subeen on 6/9/24.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var viewModel: ChatViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollView {
            if viewModel.chatDataList.isEmpty {
                
            } else {
                contentView
            }
        }
        .background(Color.chatBg)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(Color.chatBg, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    navigationRouter.pop()
                } label: {
                    Image("back")
                }
                
                Text(viewModel.otherUser?.name ?? "대화방이름")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.bkText)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Image("search_chat")
                Image("bookmark")
                Image("settings")
            }
        }
        .keyboardToolbar(height: 50) {
            HStack(spacing: 13) {
                Button {
                    
                } label: {
                    Image(.otherAdd)
                }
                
                Button {
                    
                } label: {
                    Image(.imageAdd)
                }
                
                Button {
                    
                } label: {
                    Image(.photoCamera)
                }
                
                TextField("", text: $viewModel.message)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.bkText)
                    .focused($isFocused)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 13)
                    .background(Color.greyCool)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Button {
                    
                } label: {
                    Image(.send)
                }
            }
            .padding(.horizontal, 27)
        }
    }
    
    // 채팅 목록
    var contentView: some View {
        ForEach(viewModel.chatDataList) { chatData in
            Section {
                ForEach(chatData.chats) { chat in
                    ChatItemView(message: chat.message ?? "",
                                 direction: viewModel.getDirection(id: chat.userId), date: chat.date)
                }
            } header: {
                headerView(dateStr: chatData.dateStr)
            }
        }
    }
    
    func headerView(dateStr: String) -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.clear)
                .frame(width: 76, height: 20)
                .background(Color.chatNotice)
                .cornerRadius(50)
            Text(dateStr)
                .font(.system(size: 10))
                .foregroundStyle(Color.bgWh)
        }
        .padding(.top)
    }
}

#Preview {
    NavigationStack {
        ChatView(viewModel: .init(container: DIContainer(services: StubService()), chatRoomId: "chatRoom1_id", myUserId: "user1_id", otherUserId: "user2_id"))
    }
}
