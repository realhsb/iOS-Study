//
//  NavigationRouter.swift
//  LMessenger
//
//  Created by Subeen on 6/9/24.
//

import Foundation

class NavigationRouter: ObservableObject {
    
    @Published var destinations: [NavigationDestination] = []
    
    func push(to view: NavigationDestination) {
        destinations.append(view)
    }
    
    func pop() {
        _ = destinations.popLast()
    }
    
    func popToRootView() {
        destinations = []
    }
}
