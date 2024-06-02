//
//  UploadProvider.swift
//  LMessenger
//
//  Created by Subeen on 5/24/24.
//

import Foundation
import FirebaseStorage

protocol UploadProviderType {
    func upload(path: String, data: Data, fileName: String) async throws -> URL
}

class UploadProvider: UploadProviderType {
    /// 파베는 스토리지 레퍼런스 가져와서 사용
    
    let storageRef = Storage.storage().reference()
    
    func upload(path: String, data: Data, fileName: String) async throws -> URL {
        /// 업로드 경로 -> path를 받은 후, 파일 이름을 붙여 업로드
        let ref = storageRef.child(path).child(fileName) /// 여기에 업로드
        let _ = try await ref.putDataAsync(data)        /// 업로드된 url
        let url = try await ref.downloadURL()           /// 이 url을 통해 다운로드 url 생성 
        
        return url
    }
}
