//
//  ImageCacheService.swift
//  LMessenger
//
//  Created by Subeen on 6/4/24.
//

import UIKit
import Combine

protocol ImageCacheServiceType {
    // 규격 정하기
    func image(for key: String) -> AnyPublisher<UIImage?, Never>    // 컴바인으로 작업
}

class ImageCacheService: ImageCacheServiceType {
    
    let memoryStorage: MemoryStorageType
    let diskStorage: DiskStorageType
    
    init(memeoryStorage: MemoryStorageType, diskStorage: DiskStorageType) {
        self.memoryStorage = memeoryStorage
        self.diskStorage = diskStorage
    }
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        /*
         1. memory storage  | 확인
         2. disk storage    | 확인
         3. url session     | 이미지 가져와서 memory storage와 disk storage에 각각 저장 ... 컴바인으로 스트림 잇기
         */
        
        imageWithMemoryCache(for: key) // 1️⃣ 이미지 캐시 먼저 확인
            .flatMap { image -> AnyPublisher<UIImage?, Never> in
                if let image {
                    return Just(image).eraseToAnyPublisher()
                } else {
                    return self.imageWithDiskCache(for: key)  // self 써주기
                }
            }
            .eraseToAnyPublisher()
    }
    
    func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            let image = self?.memoryStorage.value(for: key) // 2️⃣ 없으면, 디스크 캐시 확인 ...
            promise(.success(image))
            
        }.eraseToAnyPublisher()
    }
    
    func imageWithDiskCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future<UIImage?, Never> { [weak self] promise in
            do {
                let image = try self?.diskStorage.value(for: key)   // error 가 발생할 수 있기 때문에, do catch로 묶어줌
                promise(.success(image))
            } catch {
                promise(.success(nil))
            }
        }
        
        
        .flatMap { image -> AnyPublisher<UIImage?, Never> in    // 타입 명시 AnyPublisher<UIImage?, Never>
            if let image {
                return Just(image)                      // 3️⃣ 디스크에 있으면 리턴, 디스크에 가져온 걸 메모리 캐시에 저장
                    .handleEvents(receiveOutput: { [weak self] image in
                        guard let image else { return }
                        self?.store(for: key, image: image, toDisk: false)  // 캐시에 저장
                    })
                    .eraseToAnyPublisher()
            } else {
                return self.remoteImage(for: key)   // 4️⃣ 없을 경우 네트워크 통신
            }
        }
        .eraseToAnyPublisher()
    }
    
    func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!) // 네트워크 통신을 하면
            .map { data, _ in   // 통신을 하면 data가 날라옴
                UIImage(data: data)
            }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image else { return }
                self?.store(for: urlString, image: image, toDisk: true) // 이미지 받고 캐시랑 디스크 둘 다 저장 ~
            })
            .eraseToAnyPublisher()
        
        // 이미지 받아온 후, storage에 저장
        // disk에만 있는 경우라면, memory cache에 저장!
    }
    
    func store(for key: String, image: UIImage, toDisk: Bool) {
        memoryStorage.store(for: key, image: image) // 기본적으로 메모리 스토리지에 저장
        
        if toDisk {
            try? diskStorage.store(for: key, image: image)
        }
    }
}

class StubImageCacheService: ImageCacheServiceType {
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        Empty().eraseToAnyPublisher()
    }
}
