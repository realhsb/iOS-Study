//
//  NavigationDestination.swift
//  LMessenger
//
//  Created by Subeen on 6/9/24.
//

import Foundation

enum NavigationDestination: Hashable {
    case chat(ChatRoomId: String, myUserId: String, otherUserId: String) //associated 값
    case search
}
