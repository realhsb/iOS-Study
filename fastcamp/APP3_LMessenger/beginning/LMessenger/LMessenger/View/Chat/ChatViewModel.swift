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
