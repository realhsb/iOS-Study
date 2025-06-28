//
//  NavigationRoutingView.swift
//  LMessenger
//
//  Created by Subeen on 6/13/24.
//

import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case let .chat(ChatRoomId, myUserId, otherUserId):
            ChatView(viewModel: .init(container: container, chatRoomId: ChatRoomId, myUserId: myUserId, otherUserId: otherUserId))
        case .search:
            SearchView()
        }
    }
}
