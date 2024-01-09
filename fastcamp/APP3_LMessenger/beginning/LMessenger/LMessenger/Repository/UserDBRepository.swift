//
//  UserDBRepository.swift
//  LMessenger
//
//  Created by Subeen on 1/7/24.
//

// UserDBRepository, UserService

import Foundation
import Combine
import FirebaseDatabase

protocol UserDBRepositoryType {
    // 해당 유저 정보를 받아서 실제 DB에 넣음
    // DB 레이어에서 다룰 수 있는 에러 타입
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
}

class UserDBRepository: UserDBRepositoryType {
    // 파베 디비에 접근하려면 레퍼런스 객체 필요
    
    var db: DatabaseReference = Database.database().reference()     // 루트
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        // dictionary
        // UserObject는 Encodable를 컨펌하기 때문에 JSONEncoder로 object -> data -> dic -> db 저장 (컴바인 연산자로)
        
//        Empty().eraseToAnyPublisher()   // 에러 잠재우기...
        
        // object를 Just를 사용해서 스트림으로 만들기
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }   // 해당 유저를 받아 encoding을 해서 data화
            .compactMap { try? JSONSerialization.jsonObject(with:$0, options:.fragmentsAllowed)} // data를 dic화
        // realtime database는 컴바인 제공 안 함.
        //flat map으로 그 안에 Future을 정의해서 스트림으로 연결
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in // Users/userId/ ...
                    self?.db.child(DBKey.Users).child(object.id).setValue(value) { error, _ in  // 해당 경로에 data 넣기
                        // 값 등록 성공/실패시 completion으로 error나 결과값 던짐
                        if let error {
                            promise(.failure(error))    // error 발생시 promise에 failure를 넘김
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
}
