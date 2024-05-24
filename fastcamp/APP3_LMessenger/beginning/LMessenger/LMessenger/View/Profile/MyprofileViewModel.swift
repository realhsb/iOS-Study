//
//  MyprofileViewModel.swift
//  LMessenger
//
//  Created by Subeen on 4/24/24.
//

import Foundation

@MainActor /// 이 클래스에 해당되는 프로퍼티가 Main에서 접근 가능함
class MyprofileViewModel: ObservableObject {
    
    /// 자신에 대한 유저 정보
    ///  프로필에서 최신 정보를 가져와야 함. 유저 아이디를 받음
    ///
    @Published var userInfo: User?
    
    private let userId: String
    
    private var container: DIContainer
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
}

