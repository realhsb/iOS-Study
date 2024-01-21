//
//  DBError.swift
//  LMessenger
//
//  Created by Subeen on 1/7/24.
//

import Foundation

enum DBError: Error {
    case error(Error)
    case emptyValue
}
