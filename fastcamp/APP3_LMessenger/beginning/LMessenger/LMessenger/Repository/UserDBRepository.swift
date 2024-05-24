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
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>   // user id를 파라미터를 전송하면 UserObject를 리턴 // Combine 버전
    func getUser(userId: String) async throws -> UserObject    // async await 버전
    func updateUser(userId: String, key: String, value: Any) async throws
    func loadUsers() -> AnyPublisher<[UserObject], DBError>              // user key 아래에 있는 정보들을 배열로 저장
    func adduserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
}

class UserDBRepository: UserDBRepositoryType {
    // 파베 디비에 접근하려면 레퍼런스 객체 필요
    
    var db: DatabaseReference = Database.database().reference()     // 루트
    
    // MARK: - DB 유저 추가
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
    
        
    // MARK: - 유저 정보 조회
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        Future<Any?, DBError> { [weak self] promise in
            // db userid 아래에 값을 넣어두기로 함.
            // getData 한 번만 읽어옴
            self?.db.child(DBKey.Users).child(userId).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    // DB에 해당 유저 정보가 있는지 체크? snapshot.value 에 결과 오브젝트가 있음.
                    // 없을 경우 nil이 아닌 NSNull이 있음 -> NSNull을 nil로 바꿔서 전달
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value)) // 딕셔너리 형태 -> data화 -> JSONDecoder를 통해 파싱
                    // 값이 snapshot?.value 안에 있음. 이걸 flatmap으로 UserObject로 변환
                }
            }
        }
        .flatMap { value in
            if let value {  // value 값이 있을 떄
                return Just(value)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }  // 스트림화 데이터 만들기
                    .decode(type: UserObject.self, decoder: JSONDecoder())      // 디코더를 통해 UserObject로 타입 변환
                    .mapError { DBError.error($0) } // error type 변환
                    .eraseToAnyPublisher()
            } else {    // 유저에 대한 정보가 없을 때 value가 없을 때 -> 실패
                return Fail(error: .emptyValue).eraseToAnyPublisher() // Fail 던지기
            
            }
        }.eraseToAnyPublisher()
    }
    
    // firebase realtime database는 async 지원, 에러 throws 가능
    func getUser(userId: String) async throws -> UserObject {
        guard let value = try await self.db.child(DBKey.Users).child(userId).getData().value else { // userId 값 가져오기
            throw DBError.emptyValue        // 값이 없다면... throws 아니고 throw
        }
        
        // 값을 정상적으로 받았다면
        // UserObject로 변환하는 과정
        let data = try JSONSerialization.data(withJSONObject: value)            // 딕셔너리 데이터화
        let userObject = try JSONDecoder().decode(UserObject.self, from: data)  // 유저오브젝트에 맞게 디코더
        return userObject
    }
    
    func updateUser(userId: String, key: String, value: Any) async throws {
        try await self.db.child(DBKey.Users).child(userId).child(key).setValue(value)   /// 해당되는 키의 값을 업데이트 하므로 .child(key) 추가
    }
    
    func loadUsers() -> AnyPublisher<[UserObject], DBError> {    // Users 가져오기
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.Users).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }   // 여기까지 딕셔너리 형태. 밑에서 유저 배열 형태로 변환
            }
        }
        .flatMap { value in
            if let dic = value as? [String: [String: Any]] { // type check / firebase 를 보고 진행 -> [UserKey: String, 기타 값들: UserObject]
                return Just(dic) // 맞다면 Just로 딕셔너리 생성
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }// trymap으로 오브젝트를 데이터화
                    .decode(type: [String: UserObject].self, decoder: JSONDecoder()) // decoding
                    .map { $0.values.map { $0 as UserObject }}  // [String: UserObject] 여기 딕셔너리에서 UserObject의 value만 뽑아옴 + map을 사용해서 $0가 UserObject인지 확인까지!!!!
                    .mapError { DBError.error($0) } // JSONSerialization 디코딩해서 나오는 에러를 DBError로 변환
                    .eraseToAnyPublisher()
            } else if value == nil {
                // 만약 데이터가 nil이라면 빈 배열 리턴
                return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher() // Just의 형식상, 에러가 내부에 존재... 에러 타입을 명시적으로 지정
            } else {    // 데이터 맞지도 않고 없는 경우
                return Fail(error: .invalidatedType).eraseToAnyPublisher()    // 에러 타입 추가
            }
        }
        .eraseToAnyPublisher()
    }
    
    func adduserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
        // 유저 정보가 배열로 넘어옴
        /*
            Users/                      // 스트림으로 users: [UserObject] 얘를 받아와 데이터화해서 딕셔너리화해야 함
                Zip의 첫번쨰 스트림은 유저정보를 변환하지 않는 퍼블리셔 / 변환하는 퍼블리셔
                 user_id: [String: Any]
                 user_id: [String: Any]
                 user_id: [String: Any]
         */
        
//        users.publisher // 유저정보가 하나씩 방출됨
        Publishers.Zip(users.publisher, users.publisher)     // 뒤에 있는 값을 데이터화해서 딕셔너리화까지
            .compactMap { origin, converted in
                if let converted = try? JSONEncoder().encode(converted) {   // converted에 넘기기
                    return (origin, converted)
                } else {
                    // 실패하면 아래 스트림에 방출되는 값이 없도록 함
                    return nil
                }
            }
            .compactMap { origin, converted in   // converted엔 인코딩된 값이 넘어옴
                if let converted = try? JSONSerialization.jsonObject(with: converted, options: .fragmentsAllowed) {
                    return (origin, converted)
                } else {
                    return nil
                }
            }
        // 변환이 됐으므로 db에 연동
            .flatMap { origin, converted in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.Users).child(origin.id).setValue(converted) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .last()  // 마지막 알려줌,  UI 업데이트
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
}
