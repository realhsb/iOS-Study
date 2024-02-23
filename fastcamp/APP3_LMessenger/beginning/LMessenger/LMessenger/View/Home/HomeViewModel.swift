//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by Subeen on 1/7/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    enum Action {
        case load
    }
    
    @Published var myUser: User?
    @Published var users: [User] = []
    
    private var userId: String
    private var continer: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, userId: String) {
        self.continer = container
        self.userId = userId
    }
    
    func send(action: Action) {
        switch action {
        case .load:  // getUser? ->  onAppear시 호출 / 친구목록도 onAppear시 불렸으면 ㅇㅇ
                    // getuser와 loadUser가 각각 호출돼도 괜찮지만, 한꺼번에 호출되는 것이 좋겠다! -> 두 스트림을 연결하여 호출
                    // getUser 호출 후, loadUser 호출
            // TODO:
            continer.services.userService.getUser(userId: userId)   // 친구 목록까지 잘 불러옴! 
                .handleEvents(receiveOutput: { [weak self] user in // 유저 정보 세팅
                    self?.myUser = user
                })  // 이 스트림의 사이드 이펙트. 이벤트 중간에 어떤 작업을 하고 싶을 때 사용
                .flatMap { user in
                    self.continer.services.userService.loadUsers(id: user.id)
                }
                .sink { completion in
                    //TODO:
                } receiveValue: { [weak self] users in
                    self?.users = users
                }.store(in: &subscriptions)
//                .sink { completion in
//                    // TODO:
//                } receiveValue: { [weak self] user in
//                    self?.myUser = user
//                }.store(in: &subscriptions)

            return
        }
    }
}

