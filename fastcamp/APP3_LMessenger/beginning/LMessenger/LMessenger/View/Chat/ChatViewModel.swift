//
//  ChatViewModel.swift
//  LMessenger
//
//  Created by Subeen on 6/22/24.
//

import Combine
import SwiftUI
import PhotosUI

class ChatViewModel: ObservableObject {
    
    enum Action {
        case load
        case addChat(String)
        case uploadImage(PhotosPickerItem?)
    }
    
    @Published var chatDataList: [ChatData] = []
    @Published var myUser: User?
    @Published var otherUser: User?
    @Published var message: String = ""
    @Published var imageSeleection: PhotosPickerItem? {
        didSet {    // 이미지가 set 됐을 때,
            send(action: .uploadImage(imageSeleection))
        }
    }
    
    private let chatRoomId: String
    private let myUserId: String
    private let otherUserId: String
    
    private var container: DIContainer
    private var subscription = Set<AnyCancellable>()
    
    init(container: DIContainer, chatRoomId: String, myUserId: String, otherUserId: String) {
        self.container = container
        self.chatRoomId = chatRoomId
        self.myUserId = myUserId
        self.otherUserId = otherUserId
        
        // message test
//        updateChatDataList(.init(chatId: "chat1_id", userId: "user1_id", message: "Hello", date: Date()))
//        updateChatDataList(.init(chatId: "chat2_id", userId: "user2_id", message: "World", date: Date()))
//        updateChatDataList(.init(chatId: "chat3_id", userId: "user1_id", message: "!!", date: Date()))
        
        bind()
    }
    
    func bind() {
        container.services.chatService.observeChat(chatRoomId: chatRoomId)
            .sink { [weak self] chat in
                guard let chat else { return }
                self?.updateChatDataList(chat)
            }.store(in: &subscription)
    }
    
    func updateChatDataList(_ chat: Chat) {
        let key = chat.date.toChatDataKey   // extension으로 date를 string 화
        
        if let index = chatDataList.firstIndex(where: { $0.dateStr == key }) {
            chatDataList[index].chats.append(chat)
        } else {
            let newChatData: ChatData = .init(dateStr: key, chats: [chat])
            chatDataList.append(newChatData)
        }
    }
    
    /// 채팅이 자신인지 상대방인지 비교
    func getDirection(id: String) -> ChatItemDirection {
        myUserId == id ? .right : .left
    }
    
    func send(action: Action) {
        switch action {
        case .load: // 친구랑 내 정보 추가
            // Zip ? 둘 중에 하나라도 정보가 없으면 어떠한 에러 처리를 해줄 수도 있기 때문.
            Publishers.Zip(container.services.userService.getUser(userId: myUserId),
                           container.services.userService.getUser(userId: otherUserId))
            .sink { completion in
                
            } receiveValue: { [weak self] myUser, otherUser in
                self?.myUser = myUser
                self?.otherUser = otherUser
            }.store(in: &subscription)
            
        case let .addChat(message):
            let chat: Chat = .init(chatId: UUID().uuidString, userId: myUserId, message: message, date: Date())
            
            container.services.chatService.addChat(chat, to: chatRoomId)
                .sink { completion in
                    
                } receiveValue: { [weak self] _ in
                    self?.message = ""
                }.store(in: &subscription)
            
        case let .uploadImage(pickerItem):
            /*
             1. data 화
             2. uploadService -> storage에 업로드
             3. chat에 추가 add
             */
            
            
            
            return
        }
    }
}

/*
    Chats/
        chatRoomId/
            chatId1/Chat
            chatId1/Chat
            chatId1/Chat
            chatId1/Chat
 
 Chat: Date > 2023.11.1
 Chat: Date > 2023.11.1
 Chat: Date > 2023.11.1
 Chat: Date > 2023.11.1
 
 */
