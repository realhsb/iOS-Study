//
//  NavigationRoutingView.swift
//  LMessenger
//
//  Created by Subeen on 6/13/24.
//

import SwiftUI

struct NavigationRoutingView: View {
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .chat:
            ChatView()
        case .search:
            SearchView()
        }
    }
}
