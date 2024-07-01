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
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never>
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
    
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never> {
        dbRepository.observeChat(chatRoomId: chatRoomId)
            .map { $0?.toModel() }
            .replaceError(with: nil)    // error 발생시, nil로 변환
            .eraseToAnyPublisher()
    }
}

class StubChatService: ChatServiceType {
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never> {
        return Empty().eraseToAnyPublisher()
    }
}
