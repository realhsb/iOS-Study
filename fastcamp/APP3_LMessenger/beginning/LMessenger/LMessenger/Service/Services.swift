//
//  Service.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import Foundation

// 프로토콜 생성 후, 그에 대한 구현체 생성
protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
    var userService: UserServiceType { get set }
    var contactService: ContactServiceType { get set }
    var photoPickerService: PhotoPickerServiceType { get set }
    var uploadService: UploadServiceType { get set }
    var imageCacheService: ImageCacheServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var contactService: ContactServiceType
    var photoPickerService: PhotoPickerServiceType
    var uploadService: UploadServiceType
    var imageCacheService: ImageCacheServiceType
    
    init() {
        self.authService = AuthenticationService()
        self.userService = UserService(dbRepository: UserDBRepository())
        self.contactService = ContactService()
        self.photoPickerService = PhotoPickerService()
        self.uploadService = UploadService(provider: UploadProvider())
        self.imageCacheService = ImageCacheService(memeoryStorage: MemoryStorage(), diskStorage: DiskStorage())
    }
}

// 프리뷰용 서비스 
class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
    var contactService: ContactServiceType = StubContactService()
    var photoPickerService: PhotoPickerServiceType = StubPhotoPickerService()
    var uploadService: UploadServiceType = StubUploadService()
    var imageCacheService: ImageCacheServiceType = StubImageCacheService()
}
