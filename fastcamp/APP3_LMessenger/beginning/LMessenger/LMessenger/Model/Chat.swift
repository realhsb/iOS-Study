//
//  Chat.swift
//  LMessenger
//
//  Created by Subeen on 6/22/24.
//

import Foundation

struct Chat: Hashable, Identifiable {
    var chatId: String
    var userId: String
    var message: String?
    var photoURL: String?
    var date: Date
    var id: String { chatId }
}

extension Chat {
    func toObject() -> ChatObject {
        .init(chatId: chatId,
              userId: userId,
              message: message,
              photoURL: photoURL,
              date: date.timeIntervalSince1970)
    }
}
