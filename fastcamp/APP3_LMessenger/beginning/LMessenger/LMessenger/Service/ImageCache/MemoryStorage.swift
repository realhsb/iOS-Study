//
//  MemoryStorage.swift
//  LMessenger
//
//  Created by Subeen on 6/4/24.
//

import UIKit

protocol MemoryStorageType {
    // 규격 정의
    
    // 캐시에서 값 가져오기
    func value(for key: String) -> UIImage?
    
    // 캐시에 저장
    func store(for key: String, image: UIImage)
}

class MemoryStorage: MemoryStorageType {
    
    // 캐시 정의
    var cache = NSCache<NSString, UIImage>() // NS 계열이라, 둘 다 클래스 타입... NS는 키-값으로 저장
    
    func value(for key: String) -> UIImage? {   // 스트링을 NSString으로 변환하여 키로 값 가져오기
        cache.object(forKey: NSString(string: key))
    }
    
    func store(for key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key)) // cost : 용량 제한, byte 단위 ... 캐시는 자체로 용량을 관리하는 정책이 ㅣㅇㅆ음 
    }
}
