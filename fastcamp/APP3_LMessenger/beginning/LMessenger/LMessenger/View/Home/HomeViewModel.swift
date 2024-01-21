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
        case getUser
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
        case .getUser:
            // TODO:
            continer.services.userService.getUser(userId: userId)
                .sink { completion in
                    // TODO:
                } receiveValue: { [weak self] user in
                    self?.myUser = user
                }.store(in: &subscriptions)

            return
        }
    }
}

