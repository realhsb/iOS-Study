//
//  PhotoImage.swift
//  LMessenger
//
//  Created by Subeen on 5/24/24.
//

import SwiftUI

struct PhotoImage: Transferable {
    
    let data: Data
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            /// JPEG로 압축
            guard let uiImage = UIImage(data: data) else {    /// 이미지화
                throw PhotoPickerError.importFailed     /// 이미지화 실패시
            }
            
            guard let data = uiImage.jpegData(compressionQuality: 0.3) else {   /// 이미지 압축
                throw PhotoPickerError.importFailed
            }
            
            return PhotoImage(data: data)
        }
    }
}
