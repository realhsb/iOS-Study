//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by Subeen on 1/7/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var myUser: User?
    @Published var users: [User] = [.stub1, .stub2]
}
