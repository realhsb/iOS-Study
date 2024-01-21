//
//  Constant.swift
//  LMessenger
//
//  Created by Subeen on 1/7/24.
//

import Foundation

typealias DBKey = Constant.DBKey

enum Constant { }

extension Constant {
    struct DBKey {
        static let Users = "Users"
        static let ChatRooms = "ChatRooms"
        static let Chats = "Chats"
    }
}

// Constant.DBkey.Users -> 길다!
// DBKey.Users
