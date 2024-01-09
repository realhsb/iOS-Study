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
}

class UserService: UserServiceType {

    private var dpRepository: UserDBRepositoryType
    
    init(dpRepository: UserDBRepositoryType) {  // 느슨한 주입을 위해서 프로토콜 타입으로 둠
        self.dpRepository = dpRepository
    }
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        // user에 대한 값을 userObject 값으로 변경. 빈번하게 발생하는 작업이므로 User 파일에 변환 함수 작성 
        dpRepository.addUser(user.toObject())
            .map { user } // 유저 정보 전달
            .mapError { .error($0) } // 에러 타입을 서비스 에러로 변경
            .eraseToAnyPublisher()
    }
    
}

class StubUserService: UserServiceType {
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    // DB 주입 받아서 해당 레파지토리에 접근 가능
    
}
