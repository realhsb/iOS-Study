//
//  PhotoPickerService.swift
//  LMessenger
//
//  Created by Subeen on 5/24/24.
//

import Combine
import SwiftUI
import PhotosUI

enum PhotoPickerError: Error {
    case importFailed
}

protocol PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError>
}

class PhotoPickerService: PhotoPickerServiceType {
    
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        
        guard let image = try await imageSelection.loadTransferable(type: PhotoImage.self) else {   // 이미지를 업로드 해야 하므로, 이미지를 Data로 본경
            throw PhotoPickerError.importFailed
        }
        return image.data
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError> {
        Future { promise in
            imageSelection.loadTransferable(type: PhotoImage.self) { result in
                switch result {
                case let .success(image):
                    guard let data = image?.data else {
                        promise(.failure(PhotoPickerError.importFailed))
                        return
                    }
                    promise(.success(data))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .mapError { .error($0) }
        .eraseToAnyPublisher()
    }
}

class StubPhotoPickerService: PhotoPickerServiceType {
    
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        return Data()
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
