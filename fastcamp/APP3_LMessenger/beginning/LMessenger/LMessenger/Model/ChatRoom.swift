//
//  ChatRoom.swift
//  LMessenger
//
//  Created by Subeen on 6/9/24.
//

import Foundation

struct ChatRoom: Hashable{
    var chatRoomId: String
    var lastMessage: String?
    var otherUserName: String
    var otherUseId: String
}

extension ChatRoom {
    
    func toObject() -> ChatRoomObject {
        .init(chatRoomId: chatRoomId,
              lastMessage: lastMessage,
              otherUserName: otherUserName,
              otherUseId: otherUseId)
    }
}

extension ChatRoom {
    static var stub1: ChatRoom {
        .init(chatRoomId: "chatRoom1_id", otherUserName: "김하늘", otherUseId: "user1_id")
    }
    
    static var stub2: ChatRoom {
        .init(chatRoomId: "chatRoom2_id", otherUserName: "김코랄", otherUseId: "user2_id")
    }
}
