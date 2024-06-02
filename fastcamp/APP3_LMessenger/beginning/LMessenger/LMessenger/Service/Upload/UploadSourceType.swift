//
//  UploadSourceType.swift
//  LMessenger
//
//  Created by Subeen on 6/2/24.
//

import Foundation

enum UploadSourceType {
    case chat(chatRoomId: String)
    case profile(userId: String)
    
    // 채팅방이나 유저가 삭제될 때 안에 있는 경로에 있는 이미지들을 다 지울 수 있음
    var path: String {
        switch self {
        case let .chat(chatRoomId): // Chats/chatRoomId/
            return "\(DBKey.Chats)/\(chatRoomId)"
        case let .profile(userId):  // Users/UserId/
            return "\(DBKey.Users)/\(userId)"
        }
    }
}
