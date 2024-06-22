//
//  Chat.swift
//  LMessenger
//
//  Created by Subeen on 6/22/24.
//

import Foundation

struct Chat: Hashable {
    var chatId: String
    var userId: String
    var message: String?
    var photoURL: String?
    var date: Date
}
