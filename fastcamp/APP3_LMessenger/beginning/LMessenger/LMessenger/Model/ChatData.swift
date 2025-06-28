//
//  ChatData.swift
//  LMessenger
//
//  Created by Subeen on 6/22/24.
//

import Foundation

struct ChatData: Hashable, Identifiable {
    var dateStr: String
    var chats: [Chat]
    var id: String { dateStr }
}
