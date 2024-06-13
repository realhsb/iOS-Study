//
//  OtherProfileViewModel.swift
//  LMessenger
//
//  Created by Subeen on 6/9/24.
//

import Foundation

@MainActor
class OtherProfileViewModel: ObservableObject {
    
    @Published var userInfo: User?
    
    private let userId: String
    private let container: DIContainer
    
    init(container: DIContainer, userId: String) {
        self.userId = userId
        self.container = container
    }
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
}
