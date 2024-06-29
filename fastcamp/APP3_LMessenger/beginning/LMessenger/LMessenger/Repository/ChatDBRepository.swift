//
//  ChatDBRepository.swift
//  LMessenger
//
//  Created by Subeen on 6/22/24.
//

import Foundation
import Combine
import FirebaseDatabase

protocol ChatDBRepositoryType {
    func addChat(_ object: ChatObject, to chatRoomId: String) -> AnyPublisher<Void, DBError>
    func childeByAutoId(chatRoomId: String) -> String
}

class ChatDBRepository: ChatDBRepositoryType {
    var db: DatabaseReference = Database.database().reference()
    
    // TODO: addChat 작성하기
    func addChat(_ object: ChatObject, to chatRoomId: String) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.Chats).child(chatRoomId).child(object.chatId).setValue(value) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func childeByAutoId(chatRoomId: String) -> String {
        let ref = db.child(DBKey.Chats).child(chatRoomId).childByAutoId()   // 이 경로에 속한 id 자동 지정 
        
        return ref.key ?? ""
    }
}
