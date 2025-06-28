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
        case requestContacts
        case presentMyProfileView
        case presentOtherProfileView(String)    // associated 타입
        case goToChat(User)
    }
    
    @Published var myUser: User?
    @Published var users: [User] = []
    @Published var phase: Phase = .notRequested // 사용자 이름, 상태메세지
    @Published var modalDestination: HomeModalDestination?
    
    var userId: String
    
    private var container: DIContainer
    private var navigationRouter: NavigationRouter
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, navigationRouter: NavigationRouter, userId: String) {
        self.container = container
        self.navigationRouter = navigationRouter
        self.userId = userId
    }
    
    func send(action: Action) {        
        switch action {
        case .load:  // getUser? ->  onAppear시 호출 / 친구목록도 onAppear시 불렸으면 ㅇㅇ
                    // getuser와 loadUser가 각각 호출돼도 괜찮지만, 한꺼번에 호출되는 것이 좋겠다! -> 두 스트림을 연결하여 호출
                    // getUser 호출 후, loadUser 호출
            phase = .loading
            
            container.services.userService.getUser(userId: userId)   // 친구 목록까지 잘 불러옴!
                .handleEvents(receiveOutput: { [weak self] user in
                    self?.myUser = user
                })
                .handleEvents(receiveOutput: { [weak self] user in // 유저 정보 세팅
                    self?.myUser = user
                })  // 이 스트림의 사이드 이펙트. 이벤트 중간에 어떤 작업을 하고 싶을 때 사용
                .flatMap { user in
                    self.container.services.userService.loadUsers(id: user.id)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {

                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)
            
        case .requestContacts:
            container.services.contactService.fetchContacts()
            // 패치가 되고나면 db에 insert
                .flatMap { users in
                    self.container.services.userService.addUserAfterContact(users: users)
                    
                }
                // 유저 정보 불러오기
                .flatMap { _ in
                    self.container.services.userService.loadUsers(id: self.userId)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)
            
        case .presentMyProfileView:
            modalDestination = .myProfile
            
        case let .presentOtherProfileView(userId):
            modalDestination = .otherProfile(userId)
            
        case let .goToChat(otherUser):
            // 채팅방 들어가기
            // 1. 채팅방 유무 확인
            // 2. 없으면 생성, 있으면 기존 채팅방 들어가기
            // ChatRooms/myUserId 여기에 내 채팅방 목록 저장 ,,,
            // ChatRooms/myUserId/otherUderId 나와 내 친구가 채팅방이 있는지 확인
            
            /// 채팅방 정보 받아오기
            container.services.chatRoomService.createChatRoomIfNeeded(myUserId: userId, otherUserId: otherUser.id, otherUserName: otherUser.name)
                .sink { completion in
                    
                } receiveValue: { [weak self] chatRoom in
                    guard let `self` = self else { return } // 옵셔널 제거
                    // 채팅뷰로 navigation
                    self.navigationRouter.push(to: .chat(ChatRoomId: chatRoom.chatRoomId,
                                                          myUserId: self.userId,
                                                          otherUserId: otherUser.id))
//                    print(self.navigationRouter.destinations)
                }.store(in: &subscriptions)

        }
    }
}


