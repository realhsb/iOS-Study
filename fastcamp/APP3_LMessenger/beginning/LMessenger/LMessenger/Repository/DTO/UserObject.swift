//
//  UserObject.swift
//  LMessenger
//
//  Created by Subeen on 1/7/24.
//

import Foundation

// 모델과 DTO의 규격은 다르지 않지만... 실무적인 구성을 위해서

struct UserObject: Codable {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}
