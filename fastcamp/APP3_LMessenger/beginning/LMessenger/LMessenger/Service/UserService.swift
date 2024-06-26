//
//  UserService.swift
//  LMessenger
//
//  Created by Subeen on 1/7/24.
//

import Foundation
import Combine

protocol UserServiceType {
    // 서비스이므로 DTO가 아닌 User 모델을 받음
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError>
    func getUser(userId: String) -> AnyPublisher<User, ServiceError>
    func getUser(userId: String) async throws -> User
    func updateDescription(userId: String, description: String) async throws
    func updateProfileURL(userId: String, urlString: String) async throws
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError>
}

class UserService: UserServiceType {

    private var dbRepository: UserDBRepositoryType
    
    init(dbRepository: UserDBRepositoryType) {  // 느슨한 주입을 위해서 프로토콜 타입으로 둠
        self.dbRepository = dbRepository
    }
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        // user에 대한 값을 userObject 값으로 변경. 빈번하게 발생하는 작업이므로 User 파일에 변환 함수 작성 
        dbRepository.addUser(user.toObject())
            .map { user } // 유저 정보 전달
            .mapError { .error($0) } // 에러 타입을 서비스 에러로 변경
            .eraseToAnyPublisher()
    }
    
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        // 해당되는 유저의 dto를 변환한 것을 보내야 함
        dbRepository.adduserAfterContact(users: users.map { $0.toObject()} )
            .mapError { .error($0) } // 에러 타입을 서비스 에러로 변경
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        dbRepository.getUser(userId: userId)    // 리턴 값으로 UserObject가 날라옴
            .map { $0.toModel() }    // UserObject를 User로 변환
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> User {
        let userObject = try await dbRepository.getUser(userId: userId)
        return userObject.toModel()
    }
    
    func updateDescription(userId: String, description: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "description", value: description) /// UserObject에서 description
    }
    
    func updateProfileURL(userId: String, urlString: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "profileURL", value: urlString) /// UserObject에서 profileURL
    }
    
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError> {
        dbRepository.loadUsers()    // 자기 자신도 포함됨
            .map { $0        // 필터 사용해서 자기 자신 제외 / [UserObject]로 나옴 map을 2번 써서
                .map { $0.toModel() }         // 배열이기 때문에 map 2번 사용 / UserObject로 바꿈
                .filter { $0.id != id }         // 자기 자신이 아닐 때만 하도록
            }
            .mapError { .error($0) }    // 에러 바꿔주기
            .eraseToAnyPublisher()
        
//        print("UserService loadUsers")
    }
}

/// 테스트
class StubUserService: UserServiceType {
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    // DB 주입 받아서 해당 레파지토리에 접근 가능

    ///  더미데이터로 뷰 테스트 
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
//        Empty().eraseToAnyPublisher()
        Just(.stub1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> User {
        return .stub1
    }
    
    func updateDescription(userId: String, description: String) async throws {
        
    }
    
    func updateProfileURL(userId: String, urlString: String) async throws {
        
    }
    
    // 친구 목록 가져오기
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError> {
//        Empty().eraseToAnyPublisher()
//        print()
        Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
}
