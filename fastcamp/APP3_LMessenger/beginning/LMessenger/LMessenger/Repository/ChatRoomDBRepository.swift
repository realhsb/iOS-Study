//
//  ChatRoomDBRepository.swift
//  LMessenger
//
//  Created by Subeen on 6/9/24.
//

import Foundation
import Combine
import FirebaseDatabase

protocol ChatRoomDBRepositoryType {
    func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError>      /// 채팅방 존재 확인
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError>
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError>
}

class ChatRoomDBRepository: ChatRoomDBRepositoryType {
    
    var db: DatabaseReference = Database.database().reference()
    
    func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.ChatRooms).child(myUserId).getData { error, snapshot in /// ChatRooms/myUserId 에서 가져옴
                if let error {      /// 에러 체크
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        } /// 딕셔너리로 값 가져옴
        .flatMap { value in
            if let value {
                return Just(value)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: ChatRoomObject?.self, decoder: JSONDecoder())  /// 디코딩 해서 ChatRoomObject로 변환
                    .mapError { DBError.error($0) }
                    .eraseToAnyPublisher()
            } else {
                return Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }  /// 스트림으로 변환 후, 인코딩
            .compactMap { try? JSONSerialization.jsonObject(with:$0, options: .fragmentsAllowed) } /// JSONSerialization을 통해 딕셔너리화
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.ChatRooms).child(myUserId).child(object.otherUseId).setValue(value) { error, _ in /// ChatRooms/myUserId/otherUseId 에 값 추가 
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
    
    // otherUserId(키) : [String: Any]
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.ChatRooms).child(myUserId).getData { error, snapshot in    // ChatRooms/myYserId
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }
        .flatMap { value in
            if let dic = value as? [String: [String: Any]] { // 타입 캐스팅
                return Just(dic)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }  // 데이터화
                    .decode(type: [String: ChatRoomObject].self, decoder: JSONDecoder()) // 디코딩
                    .map { $0.values.map { $0 as ChatRoomObject } } // ChatRoomObject 안에 있는 value 뽑아와서 array로 만들기 
                    .mapError { DBError.error($0) }
                    .eraseToAnyPublisher()
            } else if value == nil {
                return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
            } else {
                return Fail(error: .invalidatedType).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
}
