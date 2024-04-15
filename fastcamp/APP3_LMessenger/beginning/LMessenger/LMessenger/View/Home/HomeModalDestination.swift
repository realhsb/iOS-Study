//
//  HomeModalDestination.swift
//  LMessenger
//
//  Created by Subeen on 4/13/24.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(String)
    
    var id: Int {
        hashValue
    }
}
