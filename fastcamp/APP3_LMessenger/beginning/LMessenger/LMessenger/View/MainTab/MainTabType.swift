//
//  MainTabType.swift
//  LMessenger
//
//  Created by Subeen on 1/6/24.
//

import Foundation

enum MainTabType: String, CaseIterable {    // CaseIterable : 뷰에서 ForEach로 뷰 그리기
    case home
    case chat
    case phone
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .chat:
            return "대화"
        case .phone:
            return "통화"
        }
    }
    
    // tab의 아이콘을 가져오는 함수
    func imageName(selected: Bool) -> String {
        selected ? "\(rawValue)_fill" : rawValue
    }
}



