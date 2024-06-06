//
//  DiskStorage.swift
//  LMessenger
//
//  Created by Subeen on 6/4/24.
//

import UIKit

protocol DiskStorageType {
    // 디스크에서 값 가져오기
    func value(for key: String) throws -> UIImage?
    // 디스크에 값 저장하기
    func store(for key: String, image: UIImage) throws
}

class DiskStorage: DiskStorageType {
    
    let fileManager: FileManager
    let directoryURL: URL // 캐시를 저장할 경로
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageCache") // cache/ImageCache
        
        createDirectory()
    }
    
    // 폴더 생성
    // init 시에 호출
    func createDirectory() {
        guard !fileManager.fileExists(atPath: directoryURL.path()) else { return }
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
    }
    
    // 파일 이름 가져오기
    func cacheFileURL(for key: String) -> URL {
        let fileName = sha256(key)
        return directoryURL.appendingPathComponent(fileName, isDirectory: false)
    }
    
    func value(for key: String) throws -> UIImage? {
        // key에 이미지의 url
        // 길수도 있고 /가 섞여있을 수 있음. SHA 암호화
        // 값을 꺼내올 URL
        let fileURL = cacheFileURL(for: key)
        
        guard fileManager.fileExists(atPath: fileURL.path()) else { // 값이 있는지 확인
            return nil
        }
        
        let data = try Data(contentsOf: fileURL)
        return UIImage(data: data)
    }
    
    func store(for key: String, image: UIImage) throws {    // image는 네트워킹 후 받은 이미지 -> 캐시에 저장 
        let data = image.jpegData(compressionQuality: 0.5) // 이미지 압축
        let fileURL = cacheFileURL(for: key)
        try data?.write(to: fileURL)
        
    }
}
