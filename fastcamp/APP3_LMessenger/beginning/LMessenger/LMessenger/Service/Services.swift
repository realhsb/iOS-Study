//
//  Service.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import Foundation

// 프로토콜 생성 후, 그에 대한 구현체 생성
protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
    var userService: UserServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    
    init() {
        self.authService = AuthenticationService()
        self.userService = UserService(dpRepository: UserDBRepository())
    }
}

// 프리뷰용 서비스 
class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
}
