//
//  ChatService.swift
//  LMessenger
//
//  Created by Subeen on 6/29/24.
//

import Foundation
import Combine

protocol ChatServiceType {
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError>
}

class ChatService: ChatServiceType {
    
    private let dbRepository: ChatDBRepositoryType
    
    init(dbRepository: ChatDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError> {
        // TODO: 채팅 Id는 realtime database에서 제공하는 childByAutoId 는 타임스탬프 기반. 메시지를 시간순으로 자동 정렬 -> DBRepository에서 작업! 
        var chat = chat
        chat.chatId = dbRepository.childeByAutoId(chatRoomId: chatRoomId)
        
        // 오브젝트화 해서 추가하기 
        return dbRepository.addChat(chat.toObject(), to: chatRoomId)
            .map { chat }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}

class StubChatService: ChatServiceType {
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
