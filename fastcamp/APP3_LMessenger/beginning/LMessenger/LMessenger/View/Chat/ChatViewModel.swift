//
//  ChatViewModel.swift
//  LMessenger
//
//  Created by Subeen on 6/22/24.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    @Published var chatDataList: [ChatData] = []
    @Published var myUser: User?
    @Published var otherUser: User?
    
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
