//
//  Date+Extension.swift
//  LMessenger
//
//  Created by Subeen on 6/22/24.
//

import Foundation

extension Date {
    
    var toChatTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:m" // a: 오전 오후
        return formatter.string(from: self)
    }
    
    var toChatDataKey: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd E"
        
        return formatter.string(from: self)
    }
}
