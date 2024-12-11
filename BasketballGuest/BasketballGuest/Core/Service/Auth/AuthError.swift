//
//  AuthError.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import Foundation

enum AuthError: Error {
    case clientIdError
    case tokenError
    case invalidate
    case signInError
    case networkError
}
