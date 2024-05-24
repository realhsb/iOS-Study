//
//  PhotoPickerService.swift
//  LMessenger
//
//  Created by Subeen on 5/24/24.
//

import SwiftUI
import PhotosUI

enum PhotoPickerError: Error {
    case importFailed
}

protocol PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
}

class PhotoPickerService: PhotoPickerServiceType {
    
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        
        guard let image = try await imageSelection.loadTransferable(type: PhotoImage.self) else {   // 이미지를 업로드 해야 하므로, 이미지를 Data로 본경
            throw PhotoPickerError.importFailed
        }
        return image.data
    }
}

class StubPhotoPickerService: PhotoPickerServiceType {
    
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        return Data()
    }
    
}
