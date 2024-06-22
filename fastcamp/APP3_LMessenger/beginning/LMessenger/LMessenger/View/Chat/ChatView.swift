//
//  ChatView.swift
//  LMessenger
//
//  Created by Subeen on 6/9/24.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var viewModel: ChatViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ChatView(viewModel: .init(container: DIContainer(services: StubService()), chatRoomId: "chatRoom1_id", myUserId: "user1_id", otherUserId: "user2_id"))
}
