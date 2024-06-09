//
//  MyprofileViewModel.swift
//  LMessenger
//
//  Created by Subeen on 4/24/24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor /// 이 클래스에 해당되는 프로퍼티가 Main에서 접근 가능함
class MyprofileViewModel: ObservableObject {
    
    /// 자신에 대한 유저 정보
    ///  프로필에서 최신 정보를 가져와야 함. 유저 아이디를 받음
    ///
    @Published var userInfo: User?
    @Published var isPresentedDescEditView: Bool = false
    @Published var imageSelection: PhotosPickerItem? {
        // 이미지가 선택됐을 때
        didSet {
            Task {
                await updateProfileImage(pickerItem: imageSelection)
            }
        }
    }
    
    private let userId: String
    
    private var container: DIContainer
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
    
    func updateDescription(_ description: String) async {
        do {
            try await container.services.userService.updateDescription(userId: userId, description: description)
            /// 업데이트 성공시, userInfo의 description 업데이트
            userInfo?.description = description
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateProfileImage(pickerItem: PhotosPickerItem?) async {
        guard let pickerItem else { return } // 받아온 이미지가 없을 때
        
        do {
            // 1. 이미지 데이터화 2. firebase storage 업로드  // 3. db update
            let data = try await container.services.photoPickerService.loadTransferable(from: pickerItem)
            let url = try await container.services.uploadService.uploadImage(source: .profile(userId: userId), data: data)
            try await container.services.userService.updateProfileURL(userId: userId, urlString: url.absoluteString)
            
            userInfo?.profileURL = url.absoluteString
        } catch {
            print(error.localizedDescription)
        }
    }
}

