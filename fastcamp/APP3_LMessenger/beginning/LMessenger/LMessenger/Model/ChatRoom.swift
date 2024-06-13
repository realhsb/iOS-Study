//
//  ChatRoom.swift
//  LMessenger
//
//  Created by Subeen on 6/9/24.
//

import Foundation

struct ChatRoom: Codable {
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
