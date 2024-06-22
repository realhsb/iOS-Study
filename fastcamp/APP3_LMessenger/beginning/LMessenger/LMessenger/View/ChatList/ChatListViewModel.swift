//
//  ChatListViewModel.swift
//  LMessenger
//
//  Created by Subeen on 6/13/24.
//

import Foundation
import Combine

class ChatListViewModel: ObservableObject {
    
    enum Action { // onAppear시 호출되는 함수 정의
        case load
    }
    
    @Published var chatRooms: [ChatRoom] = []
    
    let userId: String // ChatListRoom에서 ChatCell을 생성할 때, 뷰모델에서 userId 가져와야 함. private 불필요.
    
    private var container: DIContainer
    private var subscription = Set<AnyCancellable>()

    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            container.services.chatRoomService.loadChatRooms(myUserId: userId)
                .sink { completion in
                    
                } receiveValue: { [weak self] chatRooms in
                    self?.chatRooms = chatRooms
                }.store(in: &subscription)

        }
    }
}
