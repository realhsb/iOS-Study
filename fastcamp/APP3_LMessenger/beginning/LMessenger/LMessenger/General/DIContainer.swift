//
//  DIContainer.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import Foundation

// EnvironmentObject에 주입될 예정. Class 타입과 ObservableObject 타입
class DIContainer: ObservableObject {
    // TODO: service
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services

    }
}


