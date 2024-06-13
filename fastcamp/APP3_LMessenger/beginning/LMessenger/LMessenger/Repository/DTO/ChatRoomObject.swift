//
//  ChatRoomObject.swift
//  LMessenger
//
//  Created by Subeen on 6/9/24.
//

import Foundation

struct ChatRoomObject: Codable {
    var chatRoomId: String
    var lastMessage: String?
    var otherUserName: String
    var otherUseId: String
}

extension ChatRoomObject {
    func toModel() -> ChatRoom {
        .init(chatRoomId: chatRoomId,
              lastMessage: lastMessage,
              otherUserName: otherUserName,
              otherUseId: otherUseId)
    }
}
