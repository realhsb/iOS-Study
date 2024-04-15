//
//  ContactService.swift
//  LMessenger
//
//  Created by Subeen on 4/12/24.
//

import Foundation
import Combine
import Contacts

enum ContactError: Error {
    case permissionDenied
}

protocol ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError>
}

class ContactService: ContactServiceType {
    
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {    // 연락처는 Comfine 제공 안 하므로, Completion으로 작성. Future 사용
        // Publisher 만들기
        Future { [weak self] promise in
            self?.fetchContacts {
                promise($0)
            }
        }
        .mapError { .error($0) }
        .eraseToAnyPublisher()
    }
    
    private func fetchContacts(completion: @escaping (Result<[User], Error>) -> Void) {
        let store = CNContactStore()
        
        // 유저 권한 요청
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            if let error {
                // error 발생시 completion에 넘겨주기
                completion(.failure(error))
                return
            }
            
            guard granted else {
                completion(.failure(ContactError.permissionDenied))
                return
            }
            
            self?.fetchContacts(store: store, completion: completion)
        }
    }
    
    // 연락처 가져오기
    private func fetchContacts(store: CNContactStore, completion: @escaping (Result<[User], Error>) -> Void) {
        // 콘택트의 속성을 가져올 키
        let keyToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        
        let request = CNContactFetchRequest(keysToFetch: keyToFetch)
        
        var users: [User] = []
        
        
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                
                // break point / 연락처에서 유저 정보가 잘 넘어왔는지
                let user: User = .init(id: UUID().uuidString, name: name, phoneNumber: phoneNumber)
                // break point / 연락처에서 유저 정보가 잘 넘어왔는지 
                users.append(user)
            }
            completion(.success(users))
            
        } catch {
            completion(.failure(error))
        }
    }
}

class StubContactService: ContactServiceType {
    
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
