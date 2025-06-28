//
//  ChatItemDirection.swift
//  LMessenger
//
//  Created by Subeen on 6/22/24.
//

import SwiftUI

enum ChatItemDirection {
    case left
    case right
    
    var backgroundColor: Color {
        switch self {
        case .left:
            return .chatColorOther
        case .right:
            return .chatColorMe
        }
    }
    
    var overlayAlignment: Alignment {
        switch self {
        case .left:
            return .topLeading
        case .right:
            return .topTrailing
        }
    }
    
    var overlayImage: Image {
        switch self {
        case .left:
            return Image(.bubbleTailLeft)
        case .right:
            return Image(.bubbleTailRight)
        }
    }
}
