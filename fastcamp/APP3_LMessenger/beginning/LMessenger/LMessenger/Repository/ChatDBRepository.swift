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
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError>
    func removeObservedHandlers()
}

class ChatDBRepository: ChatDBRepositoryType {
    var db: DatabaseReference = Database.database().reference()
    
    var observedHandler: [UInt] = []
    
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
    
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError> {
        // DB 읽고 쓰기 -> Future
        // Future는 하나의 결과가 아웃풋으로 오면 스트림 종료
        // 하지만, 스트림 유지되고 옵저빙돼야 함 -> 서브젝트 생성 후 퍼블리시
        
        let subject = PassthroughSubject<Any?, DBError>()
        
        // Chats/chatroomId
        let handler = db.child(DBKey.Chats).child(chatRoomId).observe(.childAdded) { snapshot in
            subject.send(snapshot.value) // subject 으로 값 보내기
            // observe가 리턴 되면 핸들러의 아이디가 추출됨
            // 아이디를 추후에 해지할 수 있도록 프로퍼티에 저장
        }
        
        observedHandler.append(handler)
        
        // ChatObject로 변환
        return subject
        // Any? -> ChatObject
            .flatMap { value in
                if let value {
                    return Just(value)
                        .tryMap{ try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: ChatObject?.self, decoder: JSONDecoder())
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else {
                    return Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() { // 추가된 핸들러 삭제
        // 채팅뷰에 뷰모델이 deinit 할 때 호출 (소멸자 : 클래스 인스턴스가 메모리에서 해제될때 호출되는 메서드)
        observedHandler.forEach {
            db.removeObserver(withHandle: $0)
        }
    }
}
